# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# window.start = ->
#   setTimeout (->
#     location.reload()
#     start()
#   ), 13000


window.createGraph = ->
  $("svg").remove()
  width = window.innerWidth
  height = window.innerHeight
  svg = d3.select("body").append("svg").attr("width", width).attr("height", height)
  force = d3.layout.force().gravity(.5).distance(400).charge(-500).size([width, height])
  d3.json "/graphs/1/data.json", (error, json) ->
    force.nodes(json.nodes).links(json.links).start()
    link = svg.selectAll(".link").data(json.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
      Math.sqrt(d.value) / 8
    )
    # link = svg.selectAll(".link").data(json.links).enter().append("line").attr("class", "link").style("stroke-width", 1)
    node = svg.selectAll(".node").data(json.nodes).enter().append("g").attr("class", "node").call(force.drag)
    node.append("image").attr("xlink:href", (d) ->
      d.facebook_photo
    ).attr("x", -8).attr("y", -8).attr("width", 30).attr "height", 30
    
    # node.append("text")
    #     .attr("dx", 25)
    #     .attr("dy", ".35em")
    #     .text(function(d) { return d.name });
    force.on "tick", ->
      link.attr("x1", (d) ->
        d.source.x
      ).attr("y1", (d) ->
        d.source.y
      ).attr("x2", (d) ->
        d.target.x
      ).attr "y2", (d) ->
        d.target.y

      node.attr "transform", (d) ->
        "translate(" + d.x + "," + d.y + ")"
