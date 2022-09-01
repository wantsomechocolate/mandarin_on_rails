#util.rb

module Util

  ##https://github.com/wvanbergen/chunky_png
  def randimg(size = 512, offset1 = 200, offset2 = 200, min = 0, max = 255)

    require 'chunky_png'

    # Creating an image from scratch, save as an interlaced PNG
    png = ChunkyPNG::Image.new(size, size, ChunkyPNG::Color::TRANSPARENT)

    r_start = rand(256)
    g_start = rand(256)
    b_start = rand(256)
    #a_start = rand(256)

    size.times do |x|

      r_offset1 = rand(offset1) - offset1/2 
      g_offset1 = rand(offset1) - offset1/2
      b_offset1 = rand(offset1) - offset1/2
      #a_offset1 = rand(offset1) - offset1/2

      size.times do |y|

        r_offset2 = rand(offset2) - offset2/2 
        g_offset2 = rand(offset2) - offset2/2 
        b_offset2 = rand(offset2) - offset2/2 
        #a_offset2 = rand(offset2) - offset2/2 

        r = r_start + r_offset1 + r_offset2
        g = g_start + g_offset1 + g_offset2
        b = b_start + b_offset1 + b_offset2
        #a = a_start + a_offset1 + a_offset2

        r = [[min,r].max,max].min
        g = [[min,g].max,max].min
        b = [[min,b].max,max].min
        #a = [[min,a].max,max].min

        png[x,y] = ChunkyPNG::Color.rgba(r,g,b,255)
      end
    end
    return png
  end

end