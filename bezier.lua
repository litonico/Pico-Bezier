ctrl_pts = {}
function add_pt(x,y)
 p = {}
 p.x = x
 p.y = y
 add(ctrl_pts, p)
end

-- Vector scale
function vs(v,s)
 p = {}
 p.x = v.x*s
 p.y = v.y*s
 return p
end

-- four-vector addition
function vadd4(v1,v2,v3,v4)
 p = {}
 p.x = v1.x + v2.x + v3.x + v4.x
 p.y = v1.y + v2.y + v3.y + v4.y
 return p
end

function cubic_bezier(t, ws)
 t2 = t * t
 t3 = t2 * t
 mt = 1-t
 mt2 = mt * mt
 mt3 = mt2 * mt
 return vadd4(
  vs(ws[1],mt3),
  vs(ws[2],3*mt2*t),
  vs(ws[3],3*mt*t2),
  vs(ws[4],t3)
 )
end

add_pt(10,10)
add_pt(120,30)
add_pt(20,100)
add_pt(120,120)

selected_pt = 3
cooldown_timer = 0
cooldown = false
function _update()
 h = selected_pt
 -- Move the selected control point
 if(btn(0)) then ctrl_pts[h].x -= 1 end
 if(btn(1)) then ctrl_pts[h].x += 1 end
 if(btn(2)) then ctrl_pts[h].y -= 1 end
 if(btn(3)) then ctrl_pts[h].y += 1 end

 -- Change the selected control point
 if (btn(4) and not cooldown) then
  selected_pt -= 1
  cooldown = true
 end
 if (btn(5) and not cooldown) then
  selected_pt += 1
  cooldown = true
 end

 if (selected_pt > 4) then
  selected_pt = 4
 end
 if (selected_pt < 1) then
  selected_pt = 1
 end

 -- Can't change selected pt too quickly
 if (cooldown) then
  cooldown_timer += 1
  if (cooldown_timer == 10) then
   cooldown = false
   cooldown_timer = 0
  end
 end
end

smoothness = 10

function draw_decasteljau()
 -- TODO(lito)
end

function draw_sampled(ws)
 interpolated_pts = {}
 step = 1/smoothness
 for i=1,smoothness+1 do
  j = i-1
  t = j*step
  add(interpolated_pts, cubic_bezier(t,ws))
 end

 for i=1,#interpolated_pts do
  p1 = interpolated_pts[i]
  p2 = interpolated_pts[i+1]
  if (p2 != nil) then
   line(p1.x, p1.y, p2.x, p2.y, 8)
  end
 end
end

function _draw()
 cls()

 draw_sampled(ctrl_pts)

 for p in all(ctrl_pts) do
  pset(p.x, p.y, 12)
 end
 active = ctrl_pts[selected_pt]
 pset(active.x, active.y, 10)
end
