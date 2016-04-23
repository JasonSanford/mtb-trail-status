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
        window.mtb.map = L.mapbox.map('map', 'jcsanford.41fa2f6c', {zoomControl: false})
        window.mtb.map.addLayer(pointGeojsonLayer)
        window.mtb.map.setView(L.latLng(35.228082,-80.8442896), 9)
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
  map = L.map('map', {zoomControl: false})
  L.mapbox.styleLayer('mapbox://styles/jcsanford/cimzakjzy00x8ahnpzuzsdjfa').addTo(map)
  map.addLayer(pointGeojsonLayer)
  map.setView(L.latLng(mtb.trail.geometry.coordinates[1], mtb.trail.geometry.coordinates[0]), 13)
