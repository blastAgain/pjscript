# Copyright 2004, @Last Software, Inc.

# This software is provided as an example of using the Ruby interface
# to SketchUp.

# Permission to use, copy, modify, and distribute this software for 
# any purpose and without fee is hereby granted, provided that the above
# copyright notice appear in all copies.

# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#-----------------------------------------------------------------------------

require 'sketchup.rb'

#-----------------------------------------------------------------------------

# This example shows how you can create a simple shape in a script.
# When you run this function, it will display a dialog box which prompts
# for the dimensions of a box, and then creates the box.

def create_screen

    dlg = UI::WebDialog.new("WEBDialog", true, "WEBDialog", 739, 641, 150, 150, true)
    
    ii=100
    ww=200
    hh=300
    off=0
    
    dlg.add_action_callback("on_pjsize") {|d,p|
      puts p
    if p == "1" then
      ii = d.get_element_value("skpI").to_l
      ww = d.get_element_value("skpW").to_l
      hh = d.get_element_value("skpH").to_l
      dd = d.get_element_value("skpDi").to_l
      off = 0
    elsif p == "2" then
      ii = d.get_element_value("skpI16").to_l
      ww = d.get_element_value("skpW16").to_l
      hh = d.get_element_value("skpH16").to_l
      dd = d.get_element_value("skpDi").to_l
      off = 0
    elsif p= "10" then
      ww = d.get_element_value("skpCamW").to_l
      hh = d.get_element_value("skpCamH").to_l
      dd = d.get_element_value("skpCamD").to_l
      off = -0.5
    else
    end

     # Now we can actually create the new geometry in the Model.  There are
    # a number of ways that we could actually create the geometry.  We will
    # show a couple of ways.
    
    # The first thing that we will do is bracket all of the entity creation
    # so that this looks like a single operation for undo.  If we didn't do this
    # you would get a whole bunch of separate undo items for each step
    # of the entity creation.
    model = Sketchup.active_model
    model.start_operation "PJ Screen"
    
    # We will add the new entities to the "active_entities" collection.  If
    # you are not doing a component edit, this will be the main model.
    # if you are doing a component edit, it will be the open component.
    # You could also use model.entities which is the top level collection
    # regardless of whether or not you are doing a component edit.
    entities = model.active_entities

    # If you wanted the box to be created as simple top level entities
    # rather than a Group, you could comment out the following two lines.
    group = entities.add_group
    entities = group.entities
    
    # First we will create a rectangle for the base.  There are a few
    # variations on the add_face method.  This uses the version that
    # takes points and automatically creates the edges needed.
    
    a=Sketchup.active_model.active_view.center
    pp=Sketchup.active_model.active_view.inputpoint a.x,a.y
    p=pp.position
    px=p.x
    py=p.y
    pz=p.z
    offd=hh*off


    pts = []
    pts[0] = [px, py, pz]
    pts[1] = [px+ww,py, pz]
    pts[2] = [px+ww, py,pz+hh]
    pts[3] = [px, py,pz+hh]
    base = entities.add_face pts
    #base.back_material = "pjlight"

    
    pts = []
    pts[0] = [px, py, pz]
    pts[1] = [px+ww, py, pz]
    pts[2] = [px+ww/2, py-dd, pz-offd]
    base = entities.add_face pts
    #base.back_material = "pjlight"
    
    pts = []
    pts[0] = [px+ww,py, pz]
    pts[1] = [px+ww, py,pz+hh]
    pts[2] = [px+ww/2,py-dd, pz-offd]
    base = entities.add_face pts
    #base.back_material = "pjlight"
    
    pts = []
    pts[0] = [px+ww, py,pz+hh]
    pts[1] = [px, py,pz+hh]
    pts[2] = [px+ww/2,py-dd, pz-offd]
    base = entities.add_face pts
    #base.back_material = "pjlight"
    
    pts = []
    pts[0] = [px, py,pz+hh]
    pts[1] = [px, py, pz]
    pts[2] = [px+ww/2,py-dd, pz-offd]
    base = entities.add_face pts
    #base.back_material = "pjlight"

    # You could use a similar technique to crete the other faces of
    # the box.  For this example, we will use the pushpull method instead.
    # When you use pushpull, the direction is determined by the direction
    # of the fromnt of the face.  In order to control the direction and
    # get the pushpull to go in the direction we want, we first check the
    # direction of the face normal.  If it is not in the direction that
    # we want, we will reverse the sign of the distance.
   # height = -height if( base.normal.dot(Z_AXIS) < 0 )
    
    # Now we can do the pushpull
   # base.pushpull height

    # Now we are done and we can end the operation
    model.commit_operation

 
  }
 
    html = File.dirname(__FILE__) +"/pjscript_palm_skp.html"

    dlg.set_file html

    dlg.show

end

# This shows how you can add new items to the main menu from a Ruby script.
# This will add an item called "Box" to the Create menu.

# First check to see if we have already loaded this file so that we only 
# add the item to the menu once
if( not file_loaded?("pjcamera.rb") )

    # This will add a separator to the menu, but only once
    add_separator_to_menu("Draw")
    
    # To add an item to a menu, you identify the menu, and then
    # provide a title to display and a block to execute.  In this case,
    # the block just calls the create_box function
    UI.menu("Draw").add_item("PJ_camera") { create_screen }

end

#-----------------------------------------------------------------------------
file_loaded("pjcamera.rb")
