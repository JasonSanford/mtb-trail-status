if $('body.home.index').length > 0 or $('body.trails.index').length > 0
  map
  mapShown = false

  $('a[data-toggle="tab"]').on('shown.bs.tab', (e) ->
    if $(e.target).attr('href') is '#tab-map'
      if mapShown
        map.invalidateSize()
      else
        L.mapbox.accessToken = 'pk.eyJ1IjoiamNzYW5mb3JkIiwiYSI6InRJMHZPZFUifQ.F4DMGoNgU3r2AWLY0Eni-w'
        pointGeojsonLayer = L.geoJson(mtb.trail, {
          pointToLayer: L.mapbox.marker.style
        })
        map = L.mapbox.map('map', 'jcsanford.41fa2f6c', {zoomControl: false})
        map.addLayer(pointGeojsonLayer)
        map.setView(L.latLng(35.228082,-80.8442896), 9)
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
        lineGeojsonLayer.addTo(map)

        $.ajax({
          url: '/trails.geojson'
          success: (data) ->
            lineGeojsonLayer.addData(data);
            map.fitBounds(lineGeojsonLayer.getBounds())
          error: (jqXHR, status, error) ->
            console.log('Error fetching trail GeoJSON: ' + error)
        });
  )

if $('body.trails.show').length > 0
  L.mapbox.accessToken = 'pk.eyJ1IjoiamNzYW5mb3JkIiwiYSI6InRJMHZPZFUifQ.F4DMGoNgU3r2AWLY0Eni-w'
  pointGeojsonLayer = L.geoJson(mtb.trail, {
    pointToLayer: L.mapbox.marker.style
  })
  map = L.mapbox.map('map', 'jcsanford.41fa2f6c', {zoomControl: false})
  map.addLayer(pointGeojsonLayer)
  map.setView(L.latLng(mtb.trail.geometry.coordinates[1], mtb.trail.geometry.coordinates[0]), 13)

  defaultTrailStyle =
    color:   '#0b6121'
    weight:  4
    opacity: 0.7

  selectedStyle =
    color: '#f00'

  if mtb.trail.properties.has_geojson
    map.on('click', ->
      setLoopSelected()
    )

    $('.meta').on('click', 'a.back', (event) ->
      event.preventDefault()
      setLoopSelected()
    )

    geojsonLayer = L.geoJson(null, {
      style: $.extend({}, defaultTrailStyle),
      onEachFeature: (feature, layer) ->
        layer.on('click',  (event) ->
          setLoopSelected(feature, layer)
        )
    })
    geojsonLayer.addTo(map)

    setLoopSelected = (feature, layer) ->
      geojsonLayer.eachLayer((layer) ->
        layer.setStyle($.extend({}, defaultTrailStyle))
      );
      if feature and layer
        layer.setStyle($.extend({}, selectedStyle))
        map.fitBounds(layer.getBounds())

        loopHtml = '<a class="back" href="#back"><i class="glyphicon glyphicon-chevron-left"></i></a>';
        loopHtml += feature.properties.name;
        if feature.properties.distance_miles
          loopHtml += '<small>&nbsp;' + feature.properties.distance_miles + ' mi.</small>'

        $('.meta').find('.trail').hide()
        $('.meta').find('.loop').show().find('.name').html(loopHtml).show()
      else
        $('.meta').find('.loop').hide()
        $('.meta').find('.trail').show()

    $.ajax({
      url: mtb.trail.properties.path,
      success: (data) ->
        geojsonLayer.addData(data)
        map.fitBounds(geojsonLayer.getBounds())
      error: (jqXHR, status, error) ->
        console.log('Error fetching trail GeoJSON: ' + error)
    })
