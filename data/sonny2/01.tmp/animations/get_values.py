import xml.etree.ElementTree as ET

def xml_to_lua(xml_file):
    # Parse the XML file
    tree = ET.parse(xml_file)
    root = tree.getroot()

    # Initialize the Lua code string with animations structure
    lua_code = "animations = {\n"
    current_frames = []  # To store frames for the current animation
    current_animation = None  # To keep track of the current animation
    frame_count = 1  # To keep track of the frame number

    # Navigate to the subTags where the relevant items are located
    sub_tags = root.find('subTags')

    if sub_tags is not None:
        # Loop through each 'item' in the subTags
        for item in sub_tags.findall('item'):
            # Check if the current item is a FrameLabelTag (new animation)
            if item.get('type') == "FrameLabelTag":
                animation_name = item.get('name')

                # If there is an ongoing animation, close it off
                if current_animation:
                    lua_code += f"    {''.join(current_frames)}  }},\n"

                # Start a new animation block
                lua_code += f"  {animation_name} = {{\n"
                current_frames = []  # Clear for new frames
                current_animation = animation_name

            # Check if the current item is a ShowFrameTag (new frame within animation)
            elif item.get('type') == "ShowFrameTag":
                # If there are any frames collected, add them
                if current_frames:
                    lua_code += f"    {{\n{''.join(current_frames)}    }},\n"
                    current_frames = []  # Clear for the next frame
                frame_count += 1  # Increment frame count

            # Process PlaceObject3Tag items (parts data)
            part_name = item.get('part')
            matrix = item.find('matrix')

            if part_name and matrix is not None:
                # Extract values from the matrix tag
                scale_x = matrix.get('scaleX')
                scale_y = matrix.get('scaleY')
                translate_x = matrix.get('translateX')
                translate_y = matrix.get('translateY')
                shear_x = matrix.get('rotateSkew1')
                shear_y = matrix.get('rotateSkew0')

                # Build the Lua part entry and append to the current frame list
                part_entry = (
                    f"      {part_name} = {{\n"
                    f"        z_index = 0,\n"
                    f"        scale_x = {scale_x},\n"
                    f"        scale_y = {scale_y},\n"
                    f"        x = {translate_x},\n"
                    f"        y = {translate_y},\n"
                    f"        shear_x = {shear_x},\n"
                    f"        shear_y = {shear_y},\n"
                    f"      }},\n"
                )
                current_frames.append(part_entry)

        # If there is an ongoing animation, close it off
        if current_animation and current_frames:
            lua_code += f"    {{\n{''.join(current_frames)}    }}\n  }}\n"

    lua_code += "}\n"
    return lua_code

# Specify the XML file and generate Lua code
xml_file = "input.xml"  # Replace with the actual file path
lua_output = xml_to_lua(xml_file)

# Output the generated Lua code
print(lua_output)
