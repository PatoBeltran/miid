// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui.min
//= require jquery_ujs
//= require turbolinks
//= require materialize-sprockets
//= require go
//= require tag-it.min
//= require_self

/**
 * Created by Eduardo on 5/2/15.
 */
function initDiagram() {
    if (window.goSamples) goSamples();  // init for these samples -- you don't need to call this
    var $ = go.GraphObject.make;  // for conciseness in defining templates
    myDiagram =
        $(go.Diagram, "myDiagram",  // must be the ID or reference to div
            {
                initialAutoScale: go.Diagram.UniformToFill,
                layout: $(go.LayeredDigraphLayout)
                // other Layout properties are set by the layout function, defined below
            });
    // define the Node template
    myDiagram.nodeTemplate =
        $(go.Node, "Spot",
            { locationSpot: go.Spot.Center },
            $(go.Shape, "RoundedRectangle",
                { fill: "lightgray",  // the initial value, but data-binding may provide different value
                    strokeWidth: 10,
                    desiredSize: new go.Size(100, 50) },
                new go.Binding("fill", "fill"), new go.Binding("stroke", "stroke")),
            $(go.TextBlock,
                new go.Binding("text", "text"), {
                    isMultiline: true,
                    desiredSize: new go.Size(100, 50),
                    textAlign: "center",
                    overflow: go.TextBlock.OverflowClip
                })
        );
    // define the Link template to be minimal
    myDiagram.linkTemplate =
        $(go.Link,
            { selectable: false },
            $(go.Shape));
    // generate a tree with the default values
    rebuildGraph();
}
function rebuildGraph() {
    generateDigraph();
}
// Creates a random number of randomly colored nodes.
function generateDigraph() {
    myDiagram.startTransaction("generateDigraph");
    var nodeArray = [];
    var i;

    $.ajax({
      url: "/show_tree"
    }).done(function(data) {
      for (i = 0; i < data.courses.length; i++) {
          var color = go.Brush.randomColor();
        nodeArray.push({
            key: JSON.parse(data.courses[i]).id,
            text: JSON.parse(data.courses[i]).name.substr(0,40),
            fill: color,
            stroke: color
        });
      }
      myDiagram.model.nodeDataArray = nodeArray;
      generateLinks(data.links);

      layout();
    });
    myDiagram.commitTransaction("generateDigraph");
}
// Create some link data
function generateLinks(links) {
    var linkArray = [];
    for (var i = 0; i < links.length; i++) {
      linkArray.push(JSON.parse(links[i]));
    }
    myDiagram.model.linkDataArray = linkArray;
}

function layout() {
    myDiagram.startTransaction("change Layout");
    var lay = myDiagram.layout;
    lay.direction = 90;
    lay.layerSpacing = 25;
    lay.columnSpacing = 25;
    lay.cycleRemoveOption = go.LayeredDigraphLayout.CycleDepthFirst;
    lay.layeringOption = go.LayeredDigraphLayout.LayerLongestPathSource;
    lay.initializeOption = go.LayeredDigraphLayout.InitDepthFirstOut;
    lay.aggressiveOption = go.LayeredDigraphLayout.AggressiveLess;
    lay.packOption = 7;
    lay.setsPortSpots = true;

    myDiagram.commitTransaction("change Layout");
}

function clickNode() {
    console.log("Clicked");
}

$(function() {
  // there's the gallery and the trash
  var $gallery = $("#gallery"), $diagram = $("#myDiagram");

  // let the gallery items be draggable
  $("a", $gallery).draggable({
    //                cancel: "a.ui-icon", // clicking an icon won't initiate dragging
    revert: "invalid", // when not dropped, the item will revert back to its initial position
    containment: "document",
    helper: "clone",
    cursor: "move"
  });

  // let the trash be droppable, accepting the gallery items
  $diagram.droppable({
    accept: "#gallery > a",
    drop: function (event, ui) {

      //                    deleteImage( ui.draggable );
      $.ajax({
        url: "/link_course",
        method: "POST",
        data: { course_id: ui.draggable.data("key") }
      }).done(function(data) {
        var nodeArray = [];
        myDiagram.startTransaction("generateDigraph");
        for (i = 0; i < data.courses.length; i++) {
          nodeArray.push({
            key: JSON.parse(data.courses[i]).id,
            text: JSON.parse(data.courses[i]).name,
            fill: go.Brush.randomColor()
          });
        }
        myDiagram.model.nodeDataArray = nodeArray;
        generateLinks(data.links);

        layout();
        myDiagram.commitTransaction("generateDigraph");
      });
    }
  });
  initDiagram();
});
