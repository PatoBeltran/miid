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
//= require materialize-sprockets
//= require go
//= require tag-it.min
//= require spectrum
//= require_self

/**
 * Created by Eduardo on 5/2/15.
 */


var lastClicked;

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
          { locationSpot: go.Spot.Center, deletable: true, canDelete: function() {console.log("a"); return true;} },

          $(go.Shape, "RoundedRectangle",
              { fill: "lightgray",  // the initial value, but data-binding may provide different value
                strokeWidth: 10,
                desiredSize: new go.Size(100, 50),
                mouseEnter: function() {

                }
              },
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

  myDiagram.addDiagramListener("SelectionDeleting",
      function(e) {
        var idDel = lastClicked.data.key;
        jQuery.ajax({
          url: "/unlink_course",
          data: {course_id: idDel},
          method: "POST"
        });


      }
  );

  myDiagram.addDiagramListener("ObjectSingleClicked",
      function(e) {
        var part = e.subject.part;
        lastClicked = e.subject.part;
        if (!(part instanceof go.Link)) console.log("Clicked on " + part.data.key);
      });

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
        text: JSON.parse(data.courses[i]).name,
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
  var $gallery = $("#courses"), $diagram = $("#myDiagram");

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
    accept: "#courses > a",
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
          var color = go.Brush.randomColor();
          nodeArray.push({
            key: JSON.parse(data.courses[i]).id,
            text: JSON.parse(data.courses[i]).name,
            fill: color,
            stroke: color
          });
        }
        myDiagram.model.nodeDataArray = nodeArray;
        generateLinks(data.links);

        layout();
        myDiagram.commitTransaction("generateDigraph");
      });
    }
  });
  var array = [];
  $("#myTags").tagit({
    tagSource: function(request, response)
    {
      $.ajax({
        type: "GET",
        url:        "/course_codes",
        data: {q: $("#myTags").data("ui-tagit").tagInput.val()},
        dataType:   "json",
        success: function( data ) {
          array = data;
          response( $.map( data, function( item ) {

            return {
              label:item,
              value: item
            }
          }));
        }

      });
    },
    fieldName: "restricciones",
    placeholderText: "Restricciones",
    autocomplete: {delay: 0, minLength: 1},
    beforeTagAdded: function(event, ui) {
      if(array.indexOf(ui.tagLabel) == -1) {
        return false;
      }
      if(ui.tagLabel == "not found"){
        return false;
      }
    },
    fieldName: "restricciones",
    placeholderText: "Restricciones",
    autocomplete: {delay: 0, minLength: 1},
    beforeTagAdded: function(event, ui) {
      if(array.indexOf(ui.tagLabel) == -1){
        return false;
      }
      if(ui.tagLabel == "not found"){
        return false;
      }
    }
  });


  $('#new_course').on("submit", function() {
    $.each($('.tagit-label'), function( index, value ) {
      current_val = $("#requirements_field").val();
      $("#requirements_field").val(current_val + ',' + $(value).text());
    });
  });

  $(document).ready(function(){
    $('select').material_select();
    $(".dropdown-button").dropdown();

    console.log("HEY");
    if (document.getElementById("myDiagram")) {
      initDiagram();
    }
  });
});


function searchCourse(q) {

  $.ajax({
    type: "GET",
    data: {q: q},
    url: "/search_courses",
    dataType: "json",
    success: function(data) {

      $(".classTopic").remove();

      data.forEach(function (element) {
        var newChild = $('<a href="#" class="col s12 red classTopic" data-key="'+element.id+'">' +
            '<h5 class="white-text">'+element.name+'</h5>' +
            '<div class="red-text white center border-radius-13" style="width: 26px; height: 26px; line-height: 26px; position: absolute; bottom: 10px; right: 10px;">'+element.requirements+'</div>' +
            '<h6 class="white-text" style="position: absolute; bottom: 10px;">'+element.code+'</h6>' +
            '</a>');

        $('#courses').append(newChild);

        $("a", $("#courses")).draggable({
          //                cancel: "a.ui-icon", // clicking an icon won't initiate dragging
          revert: "invalid", // when not dropped, the item will revert back to its initial position
          containment: "document",
          helper: "clone",
          cursor: "move"
        });

      });
    }
  })
}

$(window).keydown(function (e) {
      //Supr 46
      if (e.keyCode == 8) {
        console.log("A");
        myDiagram.commandHandler.deleteSelection();
      }
    }
);

