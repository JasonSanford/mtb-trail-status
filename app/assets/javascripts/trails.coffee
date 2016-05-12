attribution = "© <a href='https://www.mapbox.com/about/maps/' target='_blank'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright' target='_blank'>OpenStreetMap</a>"

if $('body.home.index').length > 0 or $('body.trails.index').length > 0
  window.mtb.map
  mapShown = false

  $('a[data-toggle="tab"]').on('shown.bs.tab', (e) ->
    $target = $(e.target)
    $target.addClass('selected').siblings('a').removeClass('selected')
    if $target.attr('href') is '#tab-map'
      if mapShown
        window.mtb.map.invalidateSize()
      else
        L.mapbox.accessToken = 'pk.eyJ1IjoiamNzYW5mb3JkIiwiYSI6InRJMHZPZFUifQ.F4DMGoNgU3r2AWLY0Eni-w'
        pointGeojsonLayer = L.geoJson(mtb.trail, {
          pointToLayer: L.mapbox.marker.style
        })
        window.mtb.map = L.map('map', {
          scrollWheelZoom: false
          zoomControl: !L.Browser.mobile
          fullscreenControl: true
        })
        window.mtb.map.attributionControl.setPrefix('')
        window.mtb.map.on('fullscreenchange', ->
          window.mtb.map.scrollWheelZoom[if window.mtb.map.isFullscreen() then 'enable' else 'disable']()
        )
        L.mapbox.styleLayer('mapbox://styles/jcsanford/cio4ooe8m003uafnddveg2efw', {attribution}).addTo(window.mtb.map)
        window.mtb.map.addLayer(pointGeojsonLayer)
        window.mtb.map.setView(L.latLng(35.228082, -80.8442896), 9)
        mapShown = true

        lineGeojsonLayer = L.geoJson(null, {
          pointToLayer: L.mapbox.marker.style,
          onEachFeature: (feature, layer) ->
            p = feature.properties
            popupHtml = [
              '<h2><a href="' + feature.properties.path + '">' + p.display_name + '</a></h2>',
              '<h3>' + p.status + ' - ' + p.status_date_string + '</h3>'
            ]
            layer.bindPopup(popupHtml.join(''))
        })
        lineGeojsonLayer.addTo(window.mtb.map)

        $.ajax({
          url: '/trails.geojson'
          success: (data) ->
            lineGeojsonLayer.addData(data);
            window.mtb.map.fitBounds(lineGeojsonLayer.getBounds())
          error: (jqXHR, status, error) ->
            console.log('Error fetching trail GeoJSON: ' + error)
        });
  )

if $('body.trails.show').length > 0
  L.mapbox.accessToken = 'pk.eyJ1IjoiamNzYW5mb3JkIiwiYSI6InRJMHZPZFUifQ.F4DMGoNgU3r2AWLY0Eni-w'
  pointGeojsonLayer = L.geoJson(mtb.trail, {
    pointToLayer: L.mapbox.marker.style
  })
  map = window.map = L.map('map', {
    scrollWheelZoom: false
    zoomControl: !L.Browser.mobile
    fullscreenControl: true
  })
  map.attributionControl.setPrefix('')
  map.on('fullscreenchange', ->
    map.scrollWheelZoom[if map.isFullscreen() then 'enable' else 'disable']()
  )
  L.mapbox.styleLayer('mapbox://styles/jcsanford/cio4ooe8m003uafnddveg2efw', {attribution}).addTo(map)
  map.addLayer(pointGeojsonLayer)

  if mtb.trail.properties.map_center_latitude and mtb.trail.properties.map_center_longitude
    latitude  = mtb.trail.properties.map_center_latitude
    longitude = mtb.trail.properties.map_center_longitude
  else
    latitude  = mtb.trail.geometry.coordinates[1]
    longitude = mtb.trail.geometry.coordinates[0]

  map.setView(L.latLng(latitude, longitude), 13)

  if $('.forecast-container').css('float') is 'left'
    # If the forecasts are side by side adjust their heights to match the highest
    maxForecastHeight = Math.max.apply(null, $('.forecast').toArray().map((elem) -> $(elem).height()))
    $('.forecast').height(maxForecastHeight)
