<style>

.node {
  cursor: pointer;
}

.node:hover {
  stroke: #000;
  stroke-width: 2px;
}


.node--leaf {
  fill: white;
}

.label {
  font: 30px "Helvetica Neue", Helvetica, Arial, sans-serif;
  text-anchor: middle;
  text-shadow: 0 1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff, 0 -1px 0 #fff;
}

.label,
.node--root,
.node--leaf {
/*  pointer-events: none; */
}

#ecosystem-container {
  width:1000px;
  height:600px;
}

#ecosystem-svg {
  float:left;
  width:600px;
}

#ecosystem-description {
  float:left;
  width:380px;
  height:580px;
  padding: 10px;
}

</style>

# Overview of the Nix ecosystem
In this overview, we start with a background picture of how Nix relates to other approaches 
to build and deploy software.

## Historic perspective
In configuration management (thin of Chef, Puppet and Ansible)
- Explain concepts between 
  - nix expr lang
  - derivation
  - nixpkgs

## How things relate

<div id="ecosystem-container">
  <svg id="ecosystem-svg" width="600" height="600"></svg>
  <div id="ecosystem-description">
    <h3 id="ecosystem-description-title"></h3>

    <div id="ecosystem-descriptions">
      <div data-title="NixOS Ecosystem">
      The <code>nix</code> ecosystem consists of several key components.

      <ul>
        <li>
          <b>Nix</b>
          The Nix Expression Language (or <code>nixlang</code>) is used to declaratively describe how packages must be build, how your machine must be configured and how cloud resources must be created and linked to each other.
        </li>
        <li>
          <b>NixOS</b>
          The fully declarative linux distribution that builds on top <code>nix</code> and <code>nixpkgs</code>.
        </li>
        <li>TODO: nixpkgs, deployment</li>
      </ul>
    </div>
  </div>
</div>

<script src="https://d3js.org/d3.v4.min.js"></script>

<script>

var svg = d3.select("svg"),
    margin = 0,
    diameter = +svg.attr("width"),
    g = svg.append("g").attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");

var color = d3.scaleLinear()
    .domain([-1, 5])
    .range(["hsl(152,80%,80%)", "hsl(228,30%,40%)"])
    .interpolate(d3.interpolateHcl);

var pack = d3.pack()
    .size([diameter - margin, diameter - margin])
    .padding(20);


// Build a map from title -> DOM node
function buildDescriptionMap() {
  var children = document.getElementById("ecosystem-descriptions").children;
  var map  = {};
  for (var i = 0; i < children.length; i++) {
    var child = children[i];
    var title = child.getAttribute("data-title");
    map[title] = child;
  }

  return map;
}

d3.json("flare.json", function(error, root) {
  if (error) throw error;
  var textElement = document.getElementById("ecosystem-description");
  var descriptionTitleElement = document.getElementById("ecosystem-description-title");
  var descriptionsElements = buildDescriptionMap();

  console.log(descriptionsElements);

  root = d3.hierarchy(root)
      .sum(function(d) { return d.size; })
      .sort(function(a, b) { return b.value - a.value; });

  var focus = root,
      nodes = pack(root).descendants(),
      view;

  var circle = g.selectAll("circle")
    .data(nodes)
    .enter().append("circle")
      .attr("class", function(d) { return d.parent ? d.children ? "node" : "node node--leaf" : "node node--root"; })
      .style("fill", function(d) { return d.children ? color(d.depth) : null; })
      .on("click", function(d) { if (focus !== d) zoom(d), setText(d), d3.event.stopPropagation(); });

  var text = g.selectAll("text")
    .data(nodes)
    .enter().append("text")
      .attr("class", "label")
      .style("fill-opacity", function(d) { return d.parent === root ? 1 : 0; })
      .style("display", function(d) { return d.parent === root ? "inline" : "none"; })
      .text(function(d) { return d.data.name; });

  var node = g.selectAll("circle,text");

  svg.on("click", function() { zoom(root); setText(root); });

  zoomTo([root.x, root.y, root.r * 2 + margin]);
  setText(root);

  function zoom(d) {
    var focus0 = focus; focus = d;

    var transition = d3.transition()
        .duration(d3.event.altKey ? 7500 : 750)
        .tween("zoom", function(d) {
          var i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2.5 + margin]);
          return function(t) { zoomTo(i(t)); };
        });

    transition.selectAll("text")
      .filter(function(d) { console.log(d, d.parent); return d.parent === focus || this.style.display === "inline"; })
        .style("fill-opacity", function(d) { return d.parent === focus ? 1 : 0; })
        .on("start", function(d) { if (d.parent === focus) this.style.display = "inline"; })
        .on("end", function(d) { if (d.parent !== focus) this.style.display = "none"; });
  }

  function setText(d) {
    descriptionTitleElement.innerHTML = d.data.name;

    for (var title in descriptionsElements) {
      var e = descriptionsElements[title];
      if (title == d.data.name) {
        e.style.visibility = "visible";
      } else {
        e.style.visibility = "hidden";
      }
    }

//    if (d.data.html) {
//      textElement.innerHTML = "<h3>" + d.data.name + "</h3>" + d.data.html;
//    } else {
//      textElement.innerHTML = "<h3>Help</h3><p>Pick an item on the left to see it's description</p>";
//    }
  }

  function zoomTo(v) {
    var k = diameter / v[2]; view = v;
    node.attr("transform", function(d) { return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")"; });
    circle.attr("r", function(d) { return d.r * k; });
  }
});

</script>
