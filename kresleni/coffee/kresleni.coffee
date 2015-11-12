window.__init__ = () ->
	#init function
	window.width = 0
	window.height = 0
	window.pen_down = false
	window.generated = false
	window.color = ['white','0111'];
	window.array = []
	window.background = '0'
	#load_source()
	window.load_source()
	#change color
	window.change_color()
	#mennu buttons
	window.menu()
	#rewrite code
	window.code()

#menu
window.menu = () ->
	$('#fill').click () ->
		$(".bod").css("background-color", "#{window.color[0]}")
		$(".real_bod").css("background-color", "#{window.color[0]}")
		if window.width and window.height
			for y in [0..window.height-1] by 1
				for x in [0..window.width-1] by 1
					#and change array
					window.array[y][x] = ["#{window.color[0]}", "#{window.background}"+"#{window.color[1]}"]

	$('#is_background').click () ->
		if @.checked
			window.background = "1"
		else
			window.background = "0"

	$('#mirror').click () ->
		#picture mirror
		if window.height > 1 and window.width > 1
			for y in [0..window.height-1] by 1
				window.array[y].reverse()
				for x in [0..window.width-1] by 1
					#and change array
					if window.array[y][x][1][0] == "1"
						window.background = "1"
					else
						window.background = "0"
					window.color[0] = "#{window.array[y][x][0]}"
					window.color[1] = "#{window.array[y][x][1]}"
					window.action_draw(x, y, false)

	$('#rotate').click () ->
		#picture mirror
		if window.height > 1 and window.width > 1
			window.array.reverse()
			for y in [0..window.height-1] by 1
				for x in [0..window.width-1] by 1
					#and change array
					if window.array[y][x][1][0] == "1"
						window.background = "1"
					else
						window.background = "0"
					window.color[0] = "#{window.array[y][x][0]}"
					window.color[1] = "#{window.array[y][x][1]}"
					window.action_draw(x, y, false)

window.load_source = () ->
	#here is load some database
	$('#size_submit').click () ->
		window.generated = false
		window.width = $('#width').val()
		window.height = $('#height').val()
		window.generate_array()

#detection click or mouseover
window.detection_drawing = () ->
	$('body').mousedown () ->
		window.pen_down = true

	.mouseup () ->
		window.pen_down = false

	$('.bod').mouseenter () ->
		if window.pen_down
			x = $(@).data('x');
			y = $(@).data('y');
			#and change color
			window.action_draw(x, y)

	$('.bod').click () ->
		x = $(@).data('x');
		y = $(@).data('y');
		#and change color
		window.action_draw(x, y)

#action draw
window.action_draw = (x , y, change = true) ->
	#first change color
	$("#bl#{x}_#{y}").css("background-color", "#{window.color[0]}")
	
	if("#{window.background}" == "1")
		$("#bl#{x}_#{y}").css("opacity", "0.4")
		$("#bl#{x}_#{y}").css("border-style", "dashed")
	else
		$("#bl#{x}_#{y}").css("opacity", "1")
		$("#bl#{x}_#{y}").css("border-style", "solid")
	#and change real image
	$("#real_bl#{x}_#{y}").css("background-color", "#{window.color[0]}")
	#and change array
	if change
		window.array[y][x] = ["#{window.color[0]}", "#{window.background}#{window.color[1]}"]

window.getColorFromCode = (code) ->
	switch code
		when "000" then color = "black"
		when "001" then color = "blue"
		when "010" then color = "green"
		when "011" then color = "cyan"
		when "100" then color = "red"
		when "101" then color = "magenta"
		when "110" then color = "yellow"
		else color = "white"

#change colour
window.change_color = () ->
	$('.pallete').click () ->
		#and change colour
		window.color[0] = $(@).data('color')
		window.color[1] = $(@).data('color-code')
		#and change in color indicator
		$('.actual-color').css("background-color","#{window.color[0]}")

#function for rewrite code
window.code = () ->
	$('#get-code').click () ->
		$( '#code' ).val ""
		text = ""
		for y in window.array
			for x in y
				text += '"'+"#{x[1]}"+'", '
			text += "\n"

		if text.length > 2
			text = text.substring(0, text.length-3);
		$('#code').val text

	$('#get-picture').click () ->
		data = $("#code").val()
		#replace data to old format
		data = data.replace(/ /g,"")
		data = data.replace(/,/g,"")
		data = data.replace(/"/g,"")

		data = data.split "\n"
		#we have splitted data so get code
		if data.length > 0
			if data[0].length%4 == 0
				window.width = "#{data[0].length/4}"
				if data[-1 + data.length] == ""
					window.height = "#{-1 + data.length}"
					data.pop()
				else
					window.height = "#{data.length}"

				$('#width').val("#{window.width}")
				$('#height').val("#{window.height}")
				window.generated = false
				window.array = []
				window.generate_array()
				#and set colour and so on
				cr = 0
				for row in data
					#match row
					cb = 0
					blocks = row.match(/.{1,4}/g)
					for block in blocks
						#set value and set into array
						clr = window.getColorFromCode(block[1..])
						if block[0] == "1"
							window.background = "1"
						else
							window.background = "0"
						window.color[0] = "#{clr}"
						window.color[1] = "#{block[1..]}"
						window.action_draw(cb, cr)
						cb++
					cr++

			window.color[0] = "white"
			window.color[1] = "#{window.background}111"
			#and change in color indicator
			$('.actual-color').css("background-color","#{window.color[0]}")
#function for generation array
window.generate_array = () ->
	if not window.generated
		
		$( "#drawing-block" ).empty()
		$( "#real-image" ).empty()
		window.array = []
		
		for y in [0..window.height-1] by 1
			window.array[y] = []
			$( "#drawing-block" ).append( "<tr class='line' id='line_#{y}'></tr>" );
			#also generate real grid
			$( "#real-image" ).append( "<tr class='real_line' id='real_line_#{y}'></tr>" );
			for x in [0..window.width-1] by 1
				window.array[y][x] = ["white", "0111"]
				$( "#line_#{y}" ).append( "<td id='bl#{x}_#{y}' data-x='#{x}' data-y='#{y}' class='bod'></td>" );
				#also generate real block
				$( "#real_line_#{y}" ).append( "<td id='real_bl#{x}_#{y}' data-x='#{x}' data-y='#{y}' class='real_bod'></td>" );
		window.generated = true
		window.detection_drawing()
