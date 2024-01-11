pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--mushrooms
--by trasevol_dog


title_screen=true

function _init()
 t=0
 
 bco = rnd({124, 177, 745, 300, 721, 596,705})
 bc = rnd({122, 745, 596})
 
 init_objects(parse"enemies,obstacles,plants,trees,shrooms,potions")
 init_anim_info()
 init_enemy_table()
 
 player=create_player(128,128)

 hunger=0.5
 life=1
 
 lvl=1
 score=1
 spawnt=0
 
 hungershk,hungershka=0,rnd1()
 lifeshk,lifeshka=0,rnd1()
 
 hungry_lines=parse[[
im fanum taxed!,
fanum keeps taxing me!,
let's get skibidi!,
fire in the hole 😐,
f a n u m  t a x e d,
i paused my game for this,
this is nothin like o-block!,
i need kai cenat
]]

 yum_lines=parse[[
♥gyat♥,
so skibidi!,
fortnite sex!,
kumalala savesta!,
truly the rizzler!,
gettin rizzy!,
-mewing-,
feelin sigma!,
♪only in ohio♪,
nah i'd win!
]]
 
 drk=parse"0=0,0,1,1,2,1,13,6,2,4,9,3,1,1,2,4"
 mush_cols=parse"8,9,8,9,11,12,8,13,10,12,6"
 
 txtposextra=parse[[{x=0,y=3},{x=-1,y=2},{x=1,y=2},{x=-2,y=1},{x=2,y=1},{x=-2,y=0},{x=2,y=0},{x=-1,y=-1},{x=1,y=-1},{x=0,y=-2}]]
-- titlepos=parse[[{x=0,y=-1},{x=-1,y=0},{x=1,y=0},{x=-1,y=1},{x=1,y=1},{x=0,y=2}]]
 superoutlinepos=parse[[{x=-2,y=0},{x=-1,y=-1},{x=-1,y=1},{x=0,y=-2},{x=0,y=2},{x=1,y=-1},{x=1,y=1},{x=2,y=0}]]
 
 init_camera()
 
--grndptrns={
-- [0]=0b1110110110110111,
-- 0b0111111011011011,
-- 0b1011011111101101,
-- 0b1101101101111110
--}
 
 grndptrns=parse[[0=-4681,32475,-18451,-9346]]
 
 generate_forest()
 for i=0,15 do
  add_mushroom(true)
 end
 
 player.x,player.y=find_unobstructed(10,10,true)
 
 camx,camy=player.x,player.y-128
 
 music(0)
end

function _update()
 t+=0.01

 update_shake()
 
 if abs(hungershk)<0.5 then hungershk=0 end
 hungershk*=-0.7-rnd(0.2)
 hungershka+=rnd(0.1)-0.05
 if abs(lifeshk)<0.5 then lifeshk=0 end
 lifeshk*=-0.7-rnd(0.2)
 lifeshka+=rnd(0.1)-0.05
 
 spawnt+=0.01
 if spawnt>0.2 and spawnt%0.1<0.01 and group_count("enemies")<enemy_quants[min(lvl,#enemy_quants)] then
  enemy_table[frnd(min(lvl,#enemy_table))+1]()
 end

 if lvl>1 and group_count("potions")<5 then
  create_potion()
 end
 
 update_objects()
 
 camx=lerp(camx,player.x+16*player.vx,0.1)
 camy=lerp(camy,player.y+16*player.vy,0.1)
 
 if life<0 and btnp(5) then
  _init()
  sfx(11)
 end
end

function _draw()
 xmod,ymod=camx-64+shkx,camy-64+shky
 vxmod,vymod=xmod-lxmod,ymod-lymod
 lxmod,lymod=xmod,ymod
 
 camera()
 
-- for i=0,499 do
--  local x,y=rnd(128),rnd(128)
--  local c=pget(x+2*vxmod,y+2*vymod)
--  circ(x,y,1,drk[c])
-- end
 cls()
 
 camera()
 
 draw_ground()
 
 camera(xmod,ymod)
 
 draw_objects()
 
 camera()

 if title_screen then
  local y=11.5+5*cos(t)

  for c=0,15 do pal(c,0) end
  for p in all(txtposextra) do
   spr(192,8+p.x,y+p.y,14,4)
  end
  for c=0,15 do pal(c,drk[c]) end
  spr(192,8,y+1,14,4)
  for c=0,15 do pal(c,c) end
  spr(192,8,y,14,4)
  
--  draw_text("controls:",44,80,1,true,0,9,2)
--  draw_text("\148 ",84,74,1,true,0,10,4)
--  draw_text("\139 \131 \145   ",84,85,1,true,0,10,4)
--  
--  if t%0.4>0.1 then
--   draw_text("press \151 to start ",64,104,1,true,0,7,13)
--  end
  
  draw_text("controls:",44,104,1,true,0,9,2)
  draw_text("\148 ",84,98,1,true,0,10,4)
  draw_text("\139 \131 \145   ",84,109,1,true,0,10,4)
  
  if t%0.4>0.1 then
   draw_text("\151 to move to ohio ",64,80,1,true,0,7,13)
  end
  
  draw_text("BY trasevol_dog mod by katan",2,123,0,true,0,13,1)
  draw_text("FOR ld40",127,123,2,true,0,13,1)
  
  if btnp(5) then
   title_screen=false
   lifeshk=4
   hungershk=4
   sfx(11)
  end

  create_shine(xmod+4+rnd(116),ymod+8+rnd(40))
  
 elseif life>=0 then
  draw_hunger(1+hungershk*cos(hungershka),1+hungershk*sin(hungershka),hunger)
  draw_life(121+lifeshk*cos(lifeshka),1+lifeshk*sin(lifeshka),life)

  draw_text("ohio level "..lvl,64,124,1,true,0,7,13)
 else
  draw_text("y o u  g o t  m o g g e d",64,32+8*cos(t),1,true,0,14,8)
  draw_text("you swas'ed "..score.." in ohio♥",64+4*sin(t*1.5),76+4*cos(t*1.5),1,true,0,10,4)
  draw_text("\151 to become a ♪rizzler♥ ",64,104-8*cos(t),1,true,0,7,13)
 end
 
 if btn(4,1) then
  draw_debug()
 end
end


-->8
-- * updates *

function update_player(s)
 s.animt+=0.01
 life -= 0.01/(lvl+5)
 
 local spd,mov=0.5
 if life>=0 and not title_screen then
  if s.animt>=1 and s.animt%1<0.01 then
   create_textpart(s.x,s.y-8,pick(hungry_lines),10)
  end
  
  if btn(0) then s.vx-=spd mov=true end
  if btn(1) then s.vx+=spd mov=true end
  if btn(2) then s.vy-=spd mov=true end
  if btn(3) then s.vy+=spd mov=true end
 end
 
 local l=dist(s.vx,s.vy)
 local rl=min(l,2)
 s.vx=s.vx/l*rl
 s.vy=s.vy/l*rl
 
 s.x+=s.vx
 s.y+=s.vy
 
 if not mov then
  s.vx*=0.5
  s.vy*=0.5
 end
 
 avoid_obstacles(s)
 
 if s.invic>0 then
  s.invic-=0.01
  create_smoke(s.x+rnd(8)-4,s.y+rnd(8)-4,7)
  
  if s.invic%0.05<0.01 then
   sfx(6)
  end
  
  if chance(30) then
   create_shine(s.x+rnd(8)-4,s.y+rnd(8)-4)
  end
 end
 
 local col=collide_objgroup(s,"shrooms")
 if col then
  -- SHROOMS
  add_shake(2)
  oh_no(col.c)
  s.state="munch"
  s.animt=0
  
  sfx(3)
  
  for i=1,6 do
   create_smoke(s.x,s.y,chance(50) and col.c or drk[col.c],nil,nil,1+rnd(2))
  end
  
  for i=1,8 do
   create_part(s.x,s.y,chance(50) and col.c or drk[col.c])
  end

  create_textpart(s.x,s.y-8,pick(yum_lines),col.c)
  
  create_star(s.x,s.y)
  
  deregister_object(col)
  
  add_mushroom()
  
  --s.vx,s.vy=0,0 --?
  s.vx*=0.5
  s.vy*=0.5
  
  hunger+=0.1
  hungershk=16
  if hunger>1 then
   oh_no(7)
   oh_no(7)
   
   life=1
   likeshk=32
   
   create_textpart(s.x,s.y-8,pick(parse"balls!,gaming!,gay,coca cola,ice spice!"),7)
   
   add_shake(8)
   
   sfx(4)
   
   hungershk=32
   
   for i=0,4 do
    create_star(s.x,s.y)
   end
   
   for i=1,16 do
    create_smoke(s.x,s.y,7+rnd(8),nil,nil,2+rnd(3))
   end
   
   kill_all()
   
   spawnt=0
   lvl+=1
   hunger=1/(lvl+1)
  end
 end
 
 local col=collide_objgroup(s,"potions")
 if col then
 	hunger = 2
  local c,str
  if col.s==31 then
   --life
   life=1
   likeshk=32
   c=8
   cls(11)
   str="together we are muchsroom!"
  elseif col.s==47 then
   --invincibility
   s.invic=2
   c=12
   cls(12)
   str="★sigma mode★!"
  else
   --no enemies
   kill_all()
   c=10
   cls(10)
   add_shake(4)
   str="stickin out your gyat =o"
  end
  
  create_textpart(s.x,s.y,str,c)
  sfx(5)
  
  for i=1,12 do
   create_smoke(col.x,col.y,chance(50) and c or drk[c])
  end
  
  deregister_object(col)
  flip()
 end
 
 if s.state=="munch" and s.animt<0.08 or s.state=="dead" then
  --nothin
 elseif abs(s.vx)+abs(s.vy)>0.5 then
  s.state="run"
 else
  s.state="idle"
 end
 
 if abs(s.vx)>0.01 then
  s.faceleft=s.vx<0
 end
end

function kill_all()
 for e in group("enemies") do
  create_explosion(e.x,e.y,12)
  deregister_object(e)
 end
 sfx(7)
end

function auto_warp(s)
 if s.x-camx<-128 then
  s.x+=256
 elseif s.x-camx>=128 then
  s.x-=256
 end
 
 if s.y-camy<-128 then
  s.y+=256
 elseif s.y-camy>=128 then
  s.y-=256
 end
end

function update_mushroom(s)
 auto_warp(s)
 
 if chance(5) then
  create_shine(s.x+rnd(8)-4,s.y-rnd(8)+4)
 end
end


function update_follower(s)
 if (not s.ghost) and sqrdist(s.x-player.x,s.y-player.y)>sqr(70) then
  deregister_object(s)
  return
 end

 s.animt+=0.01

 local aimx,aimy=player.x,player.y
 if s.ahead then
  aimx+=8*player.vx
  aimy+=8*player.vy
 end
 
 local a=atan2(aimx-s.x,aimy-s.y)
 s.vx+=s.acc*cos(a)
 s.vy+=s.acc*sin(a)
 
 local d=dist(s.vx,s.vy)
 local nd=min(d,s.max)
 
 if nd<d then
  s.vx=s.vx/d*nd
  s.vy=s.vy/d*nd
 end
 
 s.x+=s.vx
 s.y+=s.vy
  
 if abs(s.vx)>0.01 then
  s.faceleft=s.vx<0
 end
 
 if not s.ghost then
  avoid_obstacles(s)
  
  if collide_objobj(s,player) then
   damage_player(s)
  end
 end
end

function update_rocker(s)
 update_follower(s)
 
 create_smoke(s.x-s.vx*3,s.y-s.vy*3)
end

function update_bushy(s)
 local d=sqrdist(s.x-player.x,s.y-player.y)
 
 if d>sqr(70) then
  deregister_object(s)
  return
 end
 
 if d<sqr(48) then
  s.k=1
  
  if d<sqr(20) then
   s.k=2
  
   local b1={x=s.x,y=s.y,w=40,h=12}
   local b2={x=s.x,y=s.y,w=12,h=40}
   
   local col=collide_objobj(b1,player) or collide_objobj(b2,player)
   if col then
    b1.w=32 b1.h=8
    b2.w=8 b2.h=32
    
    col=collide_objobj(b1,player) or collide_objobj(b2,player)
    
    if col then
     damage_player(s)
    end
   end
  end
 else
  s.k=0
 end
end

function update_root(s)
 if sqrdist(s.x-player.x,s.y-player.y)>sqr(70) then
  deregister_object(s)
  return
 end

 s.animt+=0.01
 
 local info=anim_info.root.only
 local sp=info.sprites[flr(s.animt/info.dt)+1]
 if sp then
  if sp==95 then
   if collide_objobj(s,player) then
    damage_player(s)
   end
  end
 else
  deregister_object(s)
 end
end

function update_cloud(s)
 if sqrdist(s.x-player.x,s.y-player.y)>sqr(76) then
  deregister_object(s)
  return
 end
 
 update_follower(s)

 if s.state=="idle" then
  if s.animt>1 then
   s.animt=0
   s.state="angry"
   s.max=1.5
   s.acc=0.05
   local a=rnd1()
   s.aimx=32*cos(a)
   s.aimy=32*sin(a)
  end
 else
  if s.animt%0.04<0.01 then
   create_rain(s.x+rnd(8)-4,s.y)
  end
  
  if s.animt%0.1<0.01 then
   create_lightning(s.x+rnd(12)-6,s.y)
   sfx(9)
  end
  
  if s.animt>1 then
   s.animt=0
   s.state="idle"
   s.max=2
   s.acc=0.1
  end
 end
end

function update_lightning(s)
 s.z-=3
 
 if s.z<0 then
  sfx(10)
  create_explosion(s.x,s.y,8)
  deregister_object(s)
 elseif s.z<16 then
  if collide_objobj(s,player) then
   damage_player(s)
  end
 end
end

function update_sun(s)
 if sqrdist(s.x-player.x,s.y-player.y)>sqr(76) then
  deregister_object(s)
  return
 end
 
 s.animt2+=0.01
 
 update_follower(s)
 
 if s.state=="idle" then
  if s.animt>1 then
   s.animt=0
   s.state="angry"
   s.max=0.9
   local a=rnd1()
   s.aimx=player.x+32*cos(a)
   s.aimy=player.y+32*sin(a)
  end
 else
  s.aimx=lerp(s.aimx,player.x,0.1)
  s.aimy=lerp(s.aimy,player.y,0.1)
  
  if s.animt2%0.03<0.01 then
   sfx(8)
  end
  
  for i=0,1 do
   create_smoke(s.aimx,s.aimy,chance(50) and 0 or 1)
  end
  
  local box={x=s.aimx,y=s.aimy,w=5,h=5}
  if collide_objobj(box,player) then
   damage_player(s)
  end
  
  if s.animt>1 then
   s.animt=0
   s.state="idle"
   s.max=2
  end
 end
end

function update_shadow(s)
 if sqrdist(s.x-player.x,s.y-player.y)>sqr(76) then
  deregister_object(s)
  return
 end

 if s.state=="thrown" then
  s.animt+=0.01
  s.x+=s.vx
  s.y+=s.vy
  s.z+=s.vz
  
  s.vz+=0.25
  
  if collide_objobj(s,player) then
   damage_player(s)
  end
  
  if s.z>0 then
   s.state="ground"
   s.animt=0
   s.z=0
   s.vz=0
  end
 elseif s.state=="ground" then
  s.animt+=0.01
  
  s.vx*=0.6
  s.vy*=0.6
  
  if s.animt>0.2 then
   s.state="idle"
   s.animt=0
  end
 else
  s.state="run"
  update_follower(s)
  
  avoid_obstacles(s)
  
  if s.animt>0.5 then
   s.state="thrown"
   s.animt=0
   
   local a=atan2(s.vx,s.vy)
   s.vx=3*cos(a)
   s.vy=3*sin(a)
   s.z=-4
   s.vz=-2
  end
 end
end

function avoid_obstacles(s)
 local col=collide_objgroup(s,"obstacles")
 if col then
  local a=atan2(s.x-col.x,s.y-col.y)
  s.vx+=0.4*cos(a)
  s.vy+=0.4*sin(a)
 end
end

function damage_player(e)
 if player.invic>0 then
  return
 end

 cls(8) flip()
 
 local a=atan2(player.x-e.x,player.y-e.y)
 local co,si=cos(a),sin(a)
 
 create_explosion((player.x+e.x)*0.5,(player.y+e.y)*0.5,8)

 player.x+=4*co
 player.y+=4*si
 player.vx+=4*co
 player.vy+=4*si
 
 e.x-=4*co
 e.y-=4*si
 e.vx=2*co
 e.vy=2*si
 
 lose_life(0.2)
 
 add_shake(4)
end

function lose_life(v)
 life-=v
 lifeshk=24*v/0.3
 
 sfx(1)
 
 if life<0 then
  --game over
  score=lvl
  lvl=1
  
  sfx(2)
  music(4)

  for e in group("enemies") do
   deregister_object(e)
  end
  
  player.state="dead"
 end
end


function update_smoke(s)
 s.x+=s.vx
 s.y+=s.vy
 
 s.vx*=0.8
 s.vy=lerp(s.vy,-1,0.2)
 
 s.r-=0.1
 if s.r<=0 then
  deregister_object(s)
  return
 end
end

function update_rain(s)
 s.z-=2
 
 if s.z<0 then
  deregister_object(s)
 end
end

function update_animpart(s)
 s.animt+=0.01
 
 if s.vx then
  s.x+=s.vx
  s.y+=s.vy
 end
 
 if anim_step(s)>=s.steps then
  deregister_object(s)
 end
end

function update_part(s)
 s.x+=s.vx
 s.y+=s.vy
 s.z+=s.vz
 
 if s.z>0 then
  s.vx*=0.5
  s.vy*=0.5
  s.vz*=-0.8
  s.z=0
 end
 
 s.vz+=0.25
 
 s.l-=0.01
 if s.l<0 then
  deregister_object(s)
 end
end

function update_textpart(s)
 s.t+=1
 
 s.y-=s.vy
 s.vy*=0.9
 
 if s.t>s.l then
  deregister_object(s)
 end
end


function add_shake(p)
 local a=rnd1()
 shkx+=p*cos(a)
 shky+=p*sin(a)
end

function update_shake()
 if abs(shkx)+abs(shky)<0.5 then
  shkx,shky=0,0
 else
  shkx*=-0.5-rnd(0.2)
  shky*=-0.5-rnd(0.2)
 end
end


-->8
-- * draws *

function draw_player(s)
-- draw_outline(draw_self,0,s)
-- draw_self(s)

-- draw_outlined_self(s)
 
-- local sinfo=anim_info[s.name][s.state or "only"]
-- local spri,wid,hei,xflip=sinfo.sprites[flr(s.animt/sinfo.dt)%#sinfo.sprites+1],sinfo.width or 1,sinfo.height or 1,s.faceleft or false
--
-- local foo=function()
--  spr(spri,s.x-wid*4,s.y-4-hei*4,wid,hei,xflip)
-- end
-- 
-- draw_super_outline(foo,c0 or 0,c1 or 7)
-- foo()
 
 
 local sinfo=anim_info[s.name][s.state]
 local spri,xflip=sinfo.sprites[flr(s.animt/sinfo.dt)%#sinfo.sprites+1],s.faceleft

 local foo=function()
  spr(spri,s.x-4,s.y-8,1,1,xflip)
 end
 
 draw_super_outline(foo,0,7)

 if s.invic>0 then
  local c=8+flr(s.invic*100)%7
  pal(8,c)
  pal(2,drk[c])
  foo()
  pal(8,8)
  pal(2,2)
 else
  foo()
 end
 
end

function draw_self(s)
 local state=s.state or "only"
 draw_anim(s.x,s.y-4,s.name,state,s.animt,s.faceleft)
end

function draw_outlined_self(s,c0,c1)
 local sinfo=anim_info[s.name][s.state or "only"]
 local spri,wid,hei,xflip=sinfo.sprites[flr(s.animt/sinfo.dt)%#sinfo.sprites+1],sinfo.width or 1,sinfo.height or 1,s.faceleft or false

 local foo=function()
  spr(spri,s.x-wid*4,s.y-4-hei*4,wid,hei,xflip)
 end
 
 draw_super_outline(foo,c0 or 0,c1 or 7)
 foo()
end


function draw_plant(s)
 local d=smolsqrdist(s.x-camx,s.y-camy)
 if d>smolsqr(64) then
  return
 end
 
 palt(5,true)
 
 for c=1,15 do pal(c,0) end
 
 spr(s.s,s.x-5,s.y-8)
 spr(s.s,s.x-3,s.y-8)
 spr(s.s,s.x-4,s.y-9)
 
 palt(5,false)
 pal(5,0)
 
 if d>smolsqr(55) then
  if d>smolsqr(60) then
   for c=1,15 do pal(c,drk[drk[c]]) end
  else
   for c=1,15 do pal(c,drk[c]) end
  end
  pal(5,0)
  
  spr(s.s,s.x-4,s.y-8)
  for c=1,15 do pal(c,c) end
 else
  for c=1,15 do pal(c,c) end
  pal(5,0)
  
  spr(s.s,s.x-4,s.y-8)
  pal(5,5)
 end
end

function draw_tree(s)
 local d=smolsqrdist(s.x-camx,s.y-camy)
 if d>smolsqr(70) then
  return
 end
 
 palt(1,true)
 
 for c=2,15 do pal(c,0) end
 
 spr(s.s,s.x-13,s.y-24,3,3)
 spr(s.s,s.x-11,s.y-24,3,3)
 spr(s.s,s.x-12,s.y-25,3,3)

 palt(1,false)
 pal(1,0)
  
 if lvl>=4 then
  local c1,c2=s.c,drk[s.c]
  
  if d>smolsqr(55) then
   if d>smolsqr(66) then
    for c=2,15 do pal(c,drk[drk[drk[c]]]) end
    pal(3,drk[drk[drk[c2]]])
    pal(11,drk[drk[drk[c1]]])
   elseif d>smolsqr(62) then
    for c=2,15 do pal(c,drk[drk[c]]) end
    pal(3,drk[drk[c2]])
    pal(11,drk[drk[c1]])
   else
    for c=2,15 do pal(c,drk[c]) end
    pal(3,drk[c2])
    pal(11,drk[c1])
   end
   
   spr(s.s,s.x-12,s.y-24,3,3)
   for c=1,15 do pal(c,c) end
  else
   for c=2,15 do pal(c,c) end
   pal(3,c2)
   pal(11,c1)
   
   spr(s.s,s.x-12,s.y-24,3,3)
   pal(1,1)
   pal(3,3)
   pal(11,11)
  end
 else
  if d>smolsqr(55) then
   if d>smolsqr(66) then
    for c=2,15 do pal(c,drk[drk[drk[c]]]) end
   elseif d>smolsqr(62) then
    for c=2,15 do pal(c,drk[drk[c]]) end
   else
    for c=2,15 do pal(c,drk[c]) end
   end
   
   spr(s.s,s.x-12,s.y-24,3,3)
   for c=1,15 do pal(c,c) end
  else
   for c=2,15 do pal(c,c) end
   
   spr(s.s,s.x-12,s.y-24,3,3)
   pal(1,1)
  end
 end
end

function draw_groundpatch(s)
 local d=smolsqrdist(s.x-camx,s.y-camy)
 if d>smolsqr(64) then
  return
 elseif d>smolsqr(55) then
  if d>smolsqr(60) then
   for c=2,15 do pal(c,drk[drk[c]]) end
  else
   for c=2,15 do pal(c,drk[c]) end
  end
  
  spr(s.s,s.x-4,s.y-4)
  for c=1,15 do pal(c,c) end
 else
  for c=2,15 do pal(c,c) end
  
  spr(s.s,s.x-4,s.y-4)
  pal(1,1)
 end
end


function draw_potion(s)
 local foo=function()
  spr(s.s,s.x-4,s.y-8+2*sin(t*2))
 end
 
 draw_super_outline(foo,0,7)
 foo()
end


function draw_walker(s)
 draw_outlined_self(s,0,8)
end

function draw_rocker(s)
 local foo=function()
  spr(s.s,s.x-4,s.y-12,1,2,s.faceleft)
 end
 
 draw_super_outline(foo,0,8)
 foo()
end

function draw_bushy(s)
 s.animt+=0.01

 local sp,w,dx
 if s.k==0 then sp=66 w=1
 elseif s.k==1 then sp=154 w=2
 else sp=140 w=4 dx=sgn(flr(s.animt*100)%2-0.5) s.x+=dx
 end

 local foo=function()
  spr(sp,s.x-w*4,s.y-w*4-4,w,w)
 end
 
 draw_super_outline(foo,0,8)
 foo()
 
 if dx then
  s.x-=dx
 end
end

function draw_root(s)
 draw_outlined_self(s,0,8)
end

function draw_cloud(s)
 s.y-=32

 local dx
 if s.state=="angry" then
  --dx=sgn(flr(s.animt*100)%2-0.5)
  dx=abs(flr(s.animt*100)%6-3)-1
  s.x+=dx
 end

 draw_outlined_self(s,0,8)
 
 if dx then
  s.x-=dx
 end
 
 s.y+=32
end

function draw_lightning(s)
 local foo=function()
  spr(s.s,s.x-4,s.y-4-s.z)
 end
 
 draw_super_outline(foo,0,8)
 foo()
end

function draw_sun(s)
 s.y-=32

 local dx
 if s.state=="angry" then
  dx=sgn(flr(s.animt*100)%2-0.5)
  s.x+=dx
 end

 local a=s.animt2
 local la,lb=8,10
 for i=0,0.875,0.125 do
  local an=a+i
  
  local xa,ya=s.x+la*cos(an),s.y+la*sin(an)
  local xb,yb=s.x+lb*cos(an),s.y+lb*sin(an)
  
  line(xa-2,ya,xb-2,yb,8)  
  line(xa-1,ya+1,xb-1,yb+1,8)  
  line(xa-1,ya-1,xb-1,yb-1,8)  
  line(xa,ya-2,xb,yb-2,8)
  line(xa,ya+2,xb,yb+2,8)
  line(xa+1,ya+1,xb+1,yb+1,8)  
  line(xa+1,ya-1,xb+1,yb-1,8)  
  line(xa+2,ya,xb+2,yb,8)  
  
  line(xa-1,ya,xb-1,yb,0)
  line(xa,ya-1,xb,yb-1,0)
  line(xa+1,ya,xb+1,yb,0)
  line(xa,ya+1,xb,yb+1,0)
  
  line(xa,ya,xb,yb,10)
 end
 
 s.y+=4
 draw_outlined_self(s,0,8)
 s.y-=4
 
 if dx then
  local foo=function()
   line(s.x,s.y,s.aimx,s.aimy,7)
   circfill(s.x,s.y,1,7)
   circfill(s.aimx,s.aimy,2,7)
  end
  
  draw_super_outline(foo,8,0)
  foo()
 end
 
 if dx then
  s.x-=dx
 end
 
 s.y+=32
end

function draw_shadow(s)
 local sinfo=anim_info[s.name][s.state]
 local spri,xflip=sinfo.sprites[flr(s.animt/sinfo.dt)%#sinfo.sprites+1],s.faceleft

 local foo=function()
  spr(spri,s.x-4,s.y-8,1,1,xflip)
 end
 
 draw_super_outline(foo,7,8)
 pal(7,s.col)
 foo()
 pal(7,7)
end


function draw_explosion(s)
 if s.p<2 then
  circfill(s.x,s.y,s.r,0)
 elseif s.p<4 then
  circfill(s.x,s.y,s.r,7)
  
  if s.p<3 and s.r>4 then
   for i=0,2 do
    local x=s.x+rnd(2.2*s.r)-1.1*s.r
    local y=s.y+rnd(2.2*s.r)-1.1*s.r
    local r=0.25*s.r+rnd(0.5*s.r)
    create_explosion(x,y,r)
   end
   
   for i=0,2 do
    create_smoke(s.x,s.y)
   end
  end
 elseif s.p<5 then
  circ(s.x,s.y,s.r,7)
 
  deregister_object(s)
  return
 end
 
 s.p+=1
end

function draw_smoke(s)
 circfill(s.x,s.y,s.r,s.c)
end

function draw_rain(s)
 spr(s.s,s.x-4,s.y-4-s.z)
end

function draw_animpart(s)
 if smolsqrdist(s.x-camx,s.y-camy)<smolsqr(64) then
  pal(5,0)
  draw_self(s)
  pal(5,5)
 end
end

function draw_part(s)
 pset(s.x,s.y+s.z,s.c)
end

function draw_textpart(s)
 local c=s.c
 
 local k=max(3-(s.l-s.t)*0.5,0)
 for i=1,k do
  c=drk[c]
 end
 
 draw_text(s.txt,s.x,s.y,1,false,0,c,drk[c])
end


function draw_ground()
 fillp(grndptrns[flr(-ymod-xmod)%4])
 if lvl<7 then
  circfill(64,64,60,137)
  circfill(64,64,56,bco)
 
 else
 	circfill(64,64,60,137)
  circfill(64,64,60,bco+((1/2)*rnd(3)))

  local k=lvl-4
  local vk=56/k
  local t=t*50
  for i=k,0,-1 do
   local r=min(t%vk+i*vk,56)
   local ci=8+flr(-i+flr(t/vk))%7
   local c=ci+drk[ci]*16
   circfill(64,64,r,c)
  end
 end
 fillp()
end


function draw_hunger(x,y,v)
 draw_bar(x,y,v,2,4,9,10,7)
 
 local txt=parse"h,U,N,G,E,R"
 for i=0,5 do
  draw_text(txt[i+1],x+9,y+5+i*8,0,true,0,9,2)
 end
end

function draw_life(x,y,v)
 draw_bar(x,y,v,1,2,8,14,7)
 
 local txt=parse"h,E,A,L,T,H"
 for i=0,5 do
  draw_text(txt[i+1],x-6,y+81+i*8,0,true,0,14,2)
 end
end

function draw_bar(x,y,v,c0,c1,c2,c3,c4)
 local w,h=6,126
 
 rectfill(x-1,y-1,x+w,y+h,0)
 
 rectfill(x,y,x+w-1,y,c1)
 rectfill(x,y,x,y+h-1,c1)
 rectfill(x+w-1,y+1,x+w-1,y+h-1,c0)
 rectfill(x+1,y+h-1,x+w-1,y+h-1,c0)
 pset(x,y,c2)
 pset(x+w-1,y+h-1,1)
 
 local yv=y+h-3-v*(h-5)
 
 if v<0 then
  return
 else
  yv=min(yv,y+h-4)
 end
 
 rectfill(x+2,yv,x+3,y+h-3,c2)
 rectfill(x+2,yv,x+2,y+h-4,c3)
 pset(x+3,yv,c3)
 pset(x+2,yv,c4)
 pset(x+3,y+h-3,c1)
 
 rectfill(x+2,y+2,x+2,y+4,c4)
 pset(x+3,y+2,c4)
 pset(x+2,y+6,c4) 
end


function draw_outline(draw,c,arg)
 all_colors_to(c)
 
 camera(xmod-1,ymod)
 draw(arg)
 camera(xmod+1,ymod)
 draw(arg)
 camera(xmod,ymod-1)
 draw(arg)
 camera(xmod,ymod+1)
 draw(arg)
 
 camera(xmod,ymod)
 all_colors_to()
end

function draw_super_outline(draw,c0,c1,arg)
 all_colors_to(c1)
 
 for k,p in pairs(superoutlinepos) do
  camera(xmod+p.x,ymod+p.y)
  draw(arg)
 end
 
 draw_outline(draw,c0,arg)
end


function draw_text(str,x,y,al,extra,c0,c1,c2)
 str=""..str
 al=al or 1
 
 if al==1 then x-=#str*2-1
 elseif al==2 then x-=#str*4 end
 
 y-=3
 
 if extra then
-- print(str,x,y+3,c0)
-- print(str,x-1,y+2,c0)
-- print(str,x+1,y+2,c0)
-- print(str,x-2,y+1,c0)
-- print(str,x+2,y+1,c0)
-- print(str,x-2,y,c0)
-- print(str,x+2,y,c0)
-- print(str,x-1,y-1,c0)
-- print(str,x+1,y-1,c0)
-- print(str,x,y-2,c0)
  for p in all(txtposextra) do
   print(str,x+p.x,y+p.y,c0)
  end
 end
 
 print(str,x+1,y+1,c2)
 print(str,x-1,y+1,c2)
 print(str,x,y+2,c2)
 print(str,x+1,y,c1)
 print(str,x-1,y,c1)
 print(str,x,y+1,c1)
 print(str,x,y-1,c1)
 print(str,x,y,c0)

end

function draw_debug()
 camera()
 rectfill(0,0,32,8,0)
 print(stat(1),0,0,7)
end


-->8
-- * creates *

function create_player(x,y)
 local p={
  x=x, y=y,
  w=6,
  h=6,
  vx=0, vy=0,
  invic=0,
  animt=0,
  name="player",
  state="idle",
  update=update_player,
  draw=draw_player,
  regs=parse"to_draw2,to_update,plants"
 }
 
 register_object(p)
 
 return p
end

function create_plant(x,y,sprite,solid)
 s={
  x=x,
  y=y,
  w=6,
  h=6,
  s=64+sprite%7,
  update=auto_warp,
  draw=draw_plant,
  regs=parse"to_draw2,to_update,plants"
 }
 
 if fget(s.s,1) then
  add(s.regs, "obstacles")
 end
 
 register_object(s)
end

function create_tree(x,y,sprite)
 s={
  x=x,
  y=y,
  w=8,
  h=8,
  s=16+(sprite%5)*3,
  c=8+frnd(7),
  update=auto_warp,
  draw=draw_tree,
  regs=parse"to_draw2,to_update,trees,obstacles"
 }
 
 register_object(s)
end

function create_groundpatch(x,y,sprite)
 s={
  x=x,
  y=y,
  w=6,
  h=6,
  s=71+sprite%4,
  update=auto_warp,
  draw=draw_groundpatch,
  regs=parse"to_draw0,to_update,plants"
 }
 
 register_object(s)
end

function add_mushroom(playersight)
 local x,y=find_unobstructed(6,6,playersight)
 create_mushroom(x,y,frnd(1024))
end

function create_mushroom(x,y,sprite)
 s={
  x=x,
  y=y,
  w=8,
  h=8,
  s=1+sprite%11,
  update=update_mushroom,
  draw=draw_plant,
  regs=parse"to_draw2,to_update,plants,shrooms"
 }
 
 s.c=mush_cols[s.s]
 
 register_object(s)
end


function create_potion()
 local x,y=find_unobstructed(6,6,false)
 
 local s={
  x=x,
  y=y,
  w=6,
  h=6,
  s=31+frnd(3)*16,
  update=auto_warp,
  draw=draw_potion,
  regs=parse"to_update,to_draw2,potions,plants"
 }
 
 register_object(s)
end


function create_walker()
 local a=rnd1()
 
 local s={
  x=player.x+64*cos(a),
  y=player.y+64*sin(a),
  vx=0,
  vy=0,
  w=6,
  h=6,
  name="flower",
  animt=rnd1(),
  acc=0.2,
  max=1,
  ahead=true,
  update=update_follower,
  draw=draw_walker,
  regs=parse"to_update,to_draw2,enemies,obstacles"
 }
 
 register_object(s)
end

function create_rocker()
 local a=rnd1()
 
 local s={
  x=player.x+64*cos(a),
  y=player.y+64*sin(a),
  vx=0,
  vy=0,
  w=6,
  h=8,
  s=67+frnd(2),
  animt=0,
  acc=0.1,
  max=2.5,
  update=update_rocker,
  draw=draw_rocker,
  regs=parse"to_update,to_draw2,enemies,obstacles"
 }
 
 register_object(s)
end

function create_bushy()
 local a
 if abs(player.vx)+abs(player.vy)>0.1 then
  a=atan2(player.vx,player.vy)+rnd(0.2)-0.1
 else
  a=rnd1()
 end
 
 local s={
  x=player.x+64*cos(a),
  y=player.y+64*sin(a),
  w=8,
  h=8,
  k=0,
  animt=0,
  update=update_bushy,
  draw=draw_bushy,
  regs=parse"to_update,to_draw2,enemies,obstacles"
 }
 
 register_object(s)
end

function create_root()
 local a
 if abs(player.vx)+abs(player.vy)>0.1 then
  a=atan2(player.vx,player.vy)+rnd(0.1)-0.05
 else
  a=rnd1()
 end
 
 local l=24+rnd(16)
 
 local s={
  x=player.x+l*cos(a),
  y=player.y+l*sin(a),
  w=8,
  h=8,
  name="root",
  animt=0,
  update=update_root,
  draw=draw_root,
  regs=parse"to_update,to_draw2,enemies,obstacles"
 }
 
 register_object(s)
end

function create_cloud()
 local a=rnd1()
 
 local s={
  x=player.x+64*cos(a),
  y=player.y+64*sin(a),
  w=14,
  h=6,
  vx=0,
  vy=0,
  name="cloud",
  state="idle",
  animt=rnd(0.5),
  acc=0.1,
  max=2,
  ghost=true,
  update=update_cloud,
  draw=draw_cloud,
  regs=parse"to_update,to_draw4,enemies"
 }
 
 register_object(s)
end

function create_lightning(x,y)
 local s={
  x=x,
  y=y,
  w=6,
  h=8,
  z=30,
  s=150+frnd(2),
  update=update_lightning,
  draw=draw_lightning,
  regs=parse"to_update,to_draw2,enemies"
 }
 
 register_object(s)
end

function create_sun()
 local a=rnd1()
 
 local s={
  x=player.x+64*cos(a),
  y=player.y+64*sin(a),
  w=6,
  h=6,
  vx=0,
  vy=0,
  name="sun",
  state="idle",
  animt=rnd(0.5),
  animt2=rnd1(),
  acc=0.3,
  max=2,
  ghost=true,
  update=update_sun,
  draw=draw_sun,
  regs=parse"to_update,to_draw4,enemies"
 }
 
 register_object(s)
end

function create_shadow()
 local a=rnd1()
 
 local s={
  x=player.x+64*cos(a),
  y=player.y+64*sin(a),
  vx=0,
  vy=0,
  w=6,
  h=6,
  name="shadow",
  state="idle",
  col=8+frnd(7),
  animt=rnd1(),
  acc=0.2,
  max=1,
  ahead=false,
  ghost=true,
  update=update_shadow,
  draw=draw_shadow,
  regs=parse"to_update,to_draw2,enemies,obstacles"
 }
 
 register_object(s)
end


function create_explosion(x,y,r)
 local e={
  x=x,
  y=y,
  r=r,
  p=0,
  draw=draw_explosion,
  regs={"to_draw4"}
 }
 
 register_object(e)
end

function create_smoke(x,y,c,a,spd,r)
 a=a or rnd1()
 spd=spd or 0.5+rnd(2.5)
 local s={
  x=x,
  y=y,
  vx=spd*cos(a),
  vy=spd*sin(a),
  r=r or rnd(3),
  c=c or pick({4,5}),
  update=update_smoke,
  draw=draw_smoke,
  regs=parse"to_update,to_draw3"
 }
 
 register_object(s)
end

function create_rain(x,y)
 local s={
  x=x,
  y=y,
  z=30,
  s=152+frnd(2),
  update=update_rain,
  draw=draw_rain,
  regs=parse"to_update,to_draw2"
 }
 
 register_object(s)
end

function create_shine(x,y)
 s={
  x=x,
  y=y,
  animt=0,
  name="shine",
  update=update_animpart,
  draw=draw_animpart,
  regs=parse"to_draw3,to_update"
 }
 
 if chance(50) then
  s.state="a"
  s.steps=5
 else
  s.state="b"
  s.steps=4
 end
 
 register_object(s)
end

function create_star(x,y)
 a=rnd1()
 spd=0.2+rnd(0.4)
 s={
  x=x,
  y=y,
  vx=spd*cos(a),
  vy=spd*sin(a),
  animt=0,
  name="star",
  steps=10,
  update=update_animpart,
  draw=draw_animpart,
  regs=parse"to_draw3,to_update"
 }
 
 register_object(s)
end

function create_part(x,y,c,spd,z,vz)
 a=rnd1()
 spd=1+rnd(2)
 s={
  x=x,
  y=y,
  vx=spd*cos(a),
  vy=spd*sin(a),
  z=4,
  vz=-2,
  c=c,
  l=0.3+rnd(0.1),
  update=update_part,
  draw=draw_part,
  regs=parse"to_draw2,to_update"
 }
 
 register_object(s)
end

function create_textpart(x,y,txt,c)
 local s={
  x=x,
  y=y,
  vy=2,
  t=0,
  l=32,
  txt=txt,
  c=c,
  update=update_textpart,
  draw=draw_textpart,
  regs=parse"to_update,to_draw4"
 }
 
 register_object(s)
end


function generate_forest()
 local plants={}
 local trees={}
 local patches={}
 
 for i=0,63 do
  local x,y=(i%8)*32+frnd(32),flr(i/8)*32+frnd(32)
  
  if x<8 then x+=8 end
  if x>248 then x+=8 end
  if y<8 then y+=8 end
  if y>248 then y+=8 end
  
  add(plants,{x=x,y=y,s=i})
  
  local x,y=(i%8)*32+frnd(32),flr(i/8)*32+frnd(32)
  
  if x<16 then x+=16 end
  if x>240 then x-=16 end
  if y<16 then y+=16 end
  if y>240 then y-=16 end
  
  add(trees,{x=x,y=y,s=i})
 end
 
 for i=0,24 do
  local x,y=(i%5)*51+frnd(51),flr(i/5)*51+frnd(51)

  if x<8 then x+=8 end
  if x>248 then x-=8 end
  if y<8 then y+=8 end
  if y>248 then y-=8 end
  
  add(patches,{x=x,y=y,s=i})
 end
 
 local separate=function(obj,grp,strt,dist,co1,co2)
  for j=strt,#grp do
   local obj2=grp[j]
   
   local d=smolsqrdist(obj.x-obj2.x,obj.y-obj2.y)
   if d<smolsqr(dist) then
    local a=atan2(obj.x-obj2.x,obj.y-obj2.y)
    local co,si=cos(a),sin(a)
    obj.x+=co1*co
    obj.y+=co1*si
    obj2.x-=co2*co
    obj2.y-=co2*si
   end
  end
 end
 
 for tt=0,7 do
  
  for i=1,64 do
   local p1=plants[i]
   
   separate(p1,plants,i+1,16,2,2)
   separate(p1,trees,1,24,4,1)
   separate(p1,patches,1,12,2,2)
  end
  
  for i=1,64 do
   local p1=trees[i]
   
   separate(p1,trees,i+1,24,4,4)
   separate(p1,patches,1,24,1,3)
  end
  
  for i=1,24 do
   local p1=patches[i]
   
   separate(p1,patches,i+1,12,2,2)
  end
  
 end
 
 for p in all(plants) do
  create_plant(p.x,p.y,p.s)
 end
 
 for p in all(trees) do
  create_tree(p.x,p.y,p.s)
 end
 
 for p in all(patches) do
  create_groundpatch(p.x,p.y,p.s)
 end
end


-->8
-- * misc *

function init_enemy_table()
 enemy_table={create_root,create_walker,create_shadow,create_rocker,create_bushy,create_cloud,create_sun}
 
 enemy_quants=parse[[
0,
3,
5,
8,
10,
12,
16,
20
]]
end

function find_unobstructed(w,h,playersight)
 local x,y
 local b=true
 while b do
  if not playersight then
   x=player.x+(chance(50) and -1 or 1) * (rnd(64)+56)
   y=player.y+(chance(50) and -1 or 1) * (rnd(64)+56)
  else
   x=player.x+rnd(224)-112
   y=player.y+rnd(224)-112
  end
  
  local obj={x=x,y=y,w=w,h=h}
  
  b=collide_objgroup(obj,"plants")
  
  if not b then
   for tr in group("trees") do
    b=x>tr.x-10-w/2 and x<tr.x+10+w/2 and y>tr.y-24-h/2 and y<tr.y+4+h/2
    if b then break end
   end
  end
 end
 
 return x,y
end

function init_camera()
 shkx,shky,camx,camy=0,0,player.x,player.y
 
 xmod,ymod=camx-64,camy-64
 lxmod,lymod,vxmod,vymod=xmod,ymod,0,0
end

function oh_no(c)
 for i=1,4 do
  local a=rnd(0x2000)
  local l=rnd(min(0x400,0x2000-a))
  local a2=rnd(0x2000-l)
  memcpy(0x6000+a2,0x6000+a,l)
  
  if chance(20) then flip() end
 end
 
 local k=6+flr(rnd(2))
 for i=0,k do
  local a=rnd(0x2000)
  local l=rnd(min(0x200,0x2000-a))
  memset(0x6000+a,c*0x11,l)
  
  if chance(20) then flip() end
 end
 flip()
end


-- * collisions *

function collide_objgroup(obj,groupname)
 for obj2 in group(groupname) do
  if obj2~=obj and collide_objobj(obj,obj2) then
   return obj2
  end
 end

 return false
end

function collide_objobj(obj1,obj2)
 return (abs(obj1.x-obj2.x)<(obj1.w+obj2.w)/2
     and abs(obj1.y-obj2.y)<(obj1.h+obj2.h)/2)
end


-->8
-- * animation *

function init_anim_info()
 anim_info=parse[[
player={
idle={
sprites={96,97,98,99,100,101,102,103},
dt=0.035
},
run={
sprites={112,113,114,115,116,117,118,119},
dt=0.015
},
munch={
sprites={80,81},
dt=0.04
},
dead={
sprites={82},
dt=1
}
},
shadow={
idle={
sprites={104,105,106,107,108,109,110,111},
dt=0.035
},
run={
sprites={120,121,122,123,124,125,126,127},
dt=0.015
},
thrown={
sprites={86},
dt=1
},
ground={
sprites={87},
dt=1
}
},
flower={
only={
sprites={75,76,77,78,79},
dt=0.02
}
},
root={
only={
sprites={88,89,90,91,92,93,92,94,92,93,92,94,95,95,95,95,95,91,89},
dt=0.02
}
},
sun={
idle={
sprites={144,144,144,144,144,145,146,147,148,144},
dt=0.04
},
angry={
sprites={149,149},
dt=1
}
},
cloud={
idle={
sprites={160,160,160,162,164,164,164,162},
width=2,
dt=0.04
},
angry={
sprites={166,166},
width=2,
dt=1
}
},
star={
only={
sprites={128,128,128,128,128,129,130,131,132,133,133},
dt=0.04
}
},
shine={
a={
sprites={134,135,136,137,138,138},
dt=0.03
},
b={
sprites={130,131,132,133,133},
dt=0.03
}
}
]]
end

function draw_anim(x,y,char,state,t,xflip)
 local sinfo=anim_info[char][state]
 local spri,wid,hei,xflip=sinfo.sprites[flr(t/sinfo.dt)%#sinfo.sprites+1],sinfo.width or 1,sinfo.height or 1,xflip or false

 spr(spri,x-wid*4,y-hei*4,wid,hei,xflip)
end

function anim_step(o)
 local state=o.state or "only"
 local info=anim_info[o.name][state]
 
 local v=flr(o.animt/info.dt%#info.sprites)
 
 return v,(o.animt%info.dt<0.01)
end


-->8
-- * objects handling *

function init_objects(groups)
 objs={}
 for name in all(groups) do
  objs[name]={}
 end
 
 objs["to_update"]={}
 for i=0,4 do
  objs["to_draw"..i]={}
 end
end

function update_objects()
 local uobjs=objs.to_update
 
 for obj in all(uobjs) do
  obj.update(obj)
 end
end

function draw_objects()
 for i=0,4 do
  local dobjs=objs["to_draw"..i]
 
  --sorting objects by depth
  for i=2,#dobjs do
   if dobjs[i-1].y>dobjs[i].y then
    local k=i
    while(k>1 and dobjs[k-1].y>dobjs[k].y) do
     local s=dobjs[k]
     dobjs[k]=dobjs[k-1]
     dobjs[k-1]=s
     k-=1
    end
   end
  end
 
  --actually drawing
  for obj in all(dobjs) do
   obj.draw(obj)
  end
 end
end

function register_object(o)
 for reg in all(o.regs) do
  add(objs[reg],o)
 end
end

function deregister_object(o)
 for reg in all(o.regs) do
  del(objs[reg],o)
 end
end

function group(name) return all(objs[name]) end

function group_count(name) return #objs[name] end


-->8
-- * utilities *

nums={}
for i=0,9 do nums[""..i]=true end
function parse(str,ar)
 local c,lc,ar,field=1,1,{}
 
 while c<=#str do
  local char=sub(str,c,c)
  
  if char=='{' then
   local sc,k=c+1,0
   while sub(str,c,c)~='}' or k>1 do
    char=sub(str,c,c)
    if char=='{' then k+=1
    elseif char=='}' then k-=1 end
    c+=1
   end
   local v=parse(sub(str,sc,c-1))
   if field then
    ar[field]=v
   else
    add(ar,v)
   end
   lc=c+2
   c+=1
  elseif char=='=' then
   field,lc=sub(str,lc,c-1),c+1
  elseif char==',' or c==#str then
   if c==#str then c+=1 end
   local v,vb=sub(str,lc,c-1),sub(str,lc+1,c-1)
   local fc=sub(v,1,1)
   if nums[fc] then v=v*1
   elseif fc=='%' then v=rnd(vb)
   elseif v=='true' then v=true
   elseif v=='false' then v=false
   end
   
   if field then
    if nums[sub(field,1,1)] then field=field*1 end
    ar[field]=v
   else
    add(ar,v)
   end
   
   field,lc=nil,c+1
  elseif char=='\n' then
   lc+=1
  end
  c+=1
 end
 
 return ar
end

function all_colors_to(c)
 if c then
  for i=0,15 do
   pal(i,c)
  end
 else
  for i=0,15 do
   pal(i,i)
  end
 end
end

function angle_diff(a1,a2)
 local a=a2-a1
 return (a+0.5)%1-0.5
end

function merge_arrays(ard,ars)
 for k,v in pairs(ars) do
  ard[k]=v
 end
 return ard
end

function smolsqr(a) return 0.01*a*a end
function smolsqrdist(x,y) return smolsqr(x)+smolsqr(y) end

function plerp(pa,pb,i) return lerp(pa.x,pb.x,i),lerp(pa.y,pb.y,i) end
function lerp(a,b,i) return (1-i)*a+i*b end
function dist(xa,ya,xb,yb) if xb then xa=xb-xa ya=yb-ya end return sqrt(sqrdist(xa,ya)) end
function sqrdist(x,y) return sqr(x)+sqr(y) end
function sqr(a) return a*a end
function round(a) return flr(a+0.5) end
function ceil(a) return flr(a+0x.ffff) end
function frnd(a) return flr(rnd(a)) end
function rnd1() return rnd(1) end
function pick(ar) return ar[flr(rnd(#ar))+1] end
function chance(a) return (rnd(100)<a) end


__gfx__
0000000000a9440000a9440000a9440000a9440000a9440000a9440000a9440000a9440000000000000000000000077600000000000000000000000000000000
00000000000440000004400000044000000440000004400000044000000440000004400000007a00007c00000000076600000000000000000000000000000000
0070070000766600007666000076660000766600007666000076660000766600007666000000a90000c107c00776066d00000000000000000000000000000000
000770000006d0000006d0000006d0000006d0000006d0000006d0000006d0000006d00007a0940000000c10076606d000000000000000000000000000000000
0007700000770d0000770d0000770d0000770d0000770d0000770d0000770d0000770d000a90a9007c00000006d6007000000000000000000000000000000000
00700700067499600675dd600678ee60067288600673bb600671cc60067644600675dd600940a900c100007c007d006600000000000000000000000000000000
0000000007a9aad0076d66d007feffd007eeeed007cbccd007dcddd0072422d0077d77d00a9094000007c0c10060007d00000000000000000000000000000000
00000000006d6d00006d6d00006d6d00006d6d00006d6d00006d6d00006d6d00006d6d0009400000000c100000d000d000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000777770000000000000000000000000000000000000000000077777700000000000000000
00000000000000000000000000000000007770770000000000000007777bb707700000000000000077777000000000000000007777b77bb777b7000000444000
000000000000000000000000000000077777777b300000000000007777bbbb7bbb00000000000077b7b7777700000000000007b77777bbbbbbbbb0000049a000
000000000000000000000000000007777b77bbb3b3000000000000777b7bb3bb333000000000077b777bbbbbb7000000000077777bbbb3b3bbbbb3000448a900
00000000007777b70000000000007777b7b33bbbb30000000000077b73bbbbbbb333000000007777bbbb3b7bbbb000000000777bbbbbbbbbbb7b330004aaa8a0
0000000077b7b73b3300000000077b777bb3bb7bbb30000000000777bbbbbb7b333b300000077b7bbbbbbbb333b3000000007b77bbb3bb3bbbbb33300498aaaa
00000077777bbbbbb3300000000077777bbbbbbbb3330000000007777bbb3bbbb3333000000777bbbbbbbbbb33330000000077bbbb3bb7bbbbb33333004998a8
000007b77bbbbbbbbb33300000077b77bbbb3bbbb3b30000000077b7b3bbbbbb33b3300000077bbbb7bb3bb3bb33300000007bb3bbbbbbbbbbbb33330000009a
0000077777bbbb7bbbb3b3000007b773bb7bbbbb333300000007777bbbbbbbb33333000000077bbbbb3bbb7bb33b3000000077bbbbbbbb7bbbbbb33300897e00
00007b77bbbbbbbbbbb33300000077b3bbbb3bb3b33300000007b7b7bbb7b3bb3b3300000007b73bbbbb7bbb3333300000007bbbbb7b3bb3bb7bb330089aaae0
0007b7bbbbb7bbb7bbbb330000007777bbbb3bbb33b3000000777bbbbbbbbbbb333b000000077bb7b3bbbb3b3333000000007bbbbbb3bbbbbbbb33309aa0a07a
00077bb3bbbbb3bbb3bb33000000777bbb3bbb33333300000077bbb3bbb3bb33b777700000007bbbbbbbbbb333333000000007b7bbbbbbbbb333333389aaaaa7
00007b3bbbbbbbbbbb3bb330000007bbbbbb3b33b3300000007bb7bbb33333b3777bbb0000007bbb7bbb333333b33000000007bbbb7b3bb3333b3333c89aaae7
00007bb33bbb7bb3bbbb3b300000077bbbb3333333000000007bbbbbb33b3337b7bbb330000007bbb33333333b3300000000073b3bbbbb3b33333330c89aaaeb
00007b333bbbbbbb33333300000007bbb77b3330307777000077bb3bbb3333b77bb3b330000000b33333333333110000000007777b3333333333311009aa9aa0
000007b3bbb3333333b33000000007bb77bbb3b007bbbbb0007b3bbbbbb32247bb7b333000000011333333b3200000000000777bbb3333333333000000ac8900
000000bbbbbb7333333300000000007b7b3b332007bb3bb30007b3373b334222b3b33330000000001114333200077700000077b3b33333333333000000060000
0000000bb3bb333b31110000000000117bbb334203b7bb3300011bb3bbb3b21133333b0000000000000442110777bb3000007b7b33b022203330000000b66b00
000000011b333341100000000000000007b333422b3b33330000007333333420111111000000000000094200777b7b3000007bb3b332442011100000035bb6b0
0000000001111422000000000000000000333042013333310000000b33b4442000000000000000000000942077b3b3300000033333114220000000005538eb60
00000000000044400000000000000000001110420011111000000001111144200000000000000000000094297b33333000000111110042200000000005388356
00000000000092400000000000000000000009420000000000000000000094200000000000000000000094240330330000000000000044200000000003533530
00000000000094420000000000000000000094400000000000000000000094420000000000000000000094440110110000000000000094220000000000355300
00000000000944220000000000000000000094220000000000000000000944220000000000000000000944222000000000000000000942220000000000050000
0007c000070000000000000000000000000000000000007b0000700000131330000013300001310000013330007c00000007c0000000000000000000007c0000
000c10000b3000070000000000000000000000007b0000b30007b0070194944300139943013ccc30001cccc300c100007c0c10000700700007c0000000c10000
07ca97c00730007b000000000000000000000000b300007b007b307b194444230194442b1cc7cccb01cc7ccb7ca97c00c1a900007c1cc1000c107c007ca97c00
0c194c10073007b30000000000000000000000007b07b0b3007b37b33444244b194444b03cccc7c703ccccc7c194c10000947c0001a9100000a9c100c194c100
0557c33007b307b000000000f0f0000040400000b30b307b07b307b301949427344942701ccccccb1cccc7cb007c333007c0c1300c9473307c940000007c3330
000c10b30bb37b30000000040f877000048770007b07b0b30bb37b3000344270194442b03c7ccc703c7bcccb00c10b330c100b337c17c130c107c33300c10b33
000550b307b37b30002f2f440086f70000864700330b303307b37b3003942b003224270003cccb000b01cc70000bb303000bb33301001b30000c1b300000b303
00000b330b33b33022f8fff45dd6866a5dd6866a000330000b33b33000bb700003b3b000003b70000003b70000b0000300000030000003000000b000000b0000
000ee0000000000000000000666dff66666d44660000000007077070000000000000000000000000000000000000000000000000000000000000000000000000
000e4000000ee0000000000065566556655665560000000007077070000000000000000000000000000000000000000000000000000000000000000000000000
00040000000e400000000000122d122d122d122d0000000000777700000000000000000000000000000000000000000000000000000000000000000000033000
44c14c44000440000000000001100110011001100000000000077000000000000000000000000000000000000000000000000000000003000003300000033000
000cc00004c14c400000000000000000000000000000000007777000000000000000000000000000000000000000000000030000000030000033000000c13c00
00011000400cc00400000000000000000000000000000000000070000000000000000000000000000000000000000000003420000000420000320000334bc233
0001010000010100001414ee00000000000000000000000000070000007777770000000000000000000420000044220000444200000444200444200004412120
0010010000100100114c444e00000000000000000000000000000000777777770004000000042000004442000444422004442220004442224442220044122b22
0000000000ee000000ee000000000000000000000000ee000000ee00000000000000000000000000000000000000000000000000000000000000000000000000
000ee000004e0000004e000000ee0000000ee0000000e4000000e4000000ee000000000000770000007700000000000000000000000077000000770000000000
000440000044000000440000004e00000004400000004400000044000000e4000007700000770000007700000077000000077000000077000000770000007700
000440000041c0000041c0000044000000044000000c1400000c1400000044000007700000777000007770000077000000077000000777000007770000007700
00c14c0044cc044004cc44000041c00000c41c000440cc440044cc40000c14000077770077770770077777000077700000777700077077770077777000077700
440cc044001100000011000044cc0440440cc04400001100000011000440cc447707707700770000007700007777077077077077000077000000770007707777
00010100001010000010110000101000001010000001010000110100000101000007070000707000007077000070700000707000000707000077070000070700
00100100001001000010000000100100001001000010010000000100001001000070070000700700007000000070070000700700007007000000070000700700
000ee000000ee000000000000000000000000000000ee000000ee000000ee0000000000000000000000000000000000000000000000000000000000000000000
000e4000000e4000000ee000000ee000000ee000000e4000000e4000000e40000007700000077000000000000000000000000000000770000007700000077000
0004400000044000000e4000000e4000000e40004404404440044004000440000007700000077000000770000007700000077000770770777007700700077000
04c14c4000c14c0000044000000440004404404400c14c0004c14c4044c14c440777777000777700000770000007700077077077007777000777777077777777
400cc004440cc04400c14c0044c14c4400c14c00000cc000000cc000000cc0007007700777077077007777007777777700777700000000000000000000077000
0001110000011000440cc044000cc000000cc0000001110000011110000111100007770000077000770770770007700000077000000000000000007000077770
01100010011001000011010000011000000110000001010000100000011000000770007007700700007707000007700000077000000000000000000007700000
00000000000000100000010000001000000100000010000001000000000000000000000000000070000007000000700000070000000000000000000000000000
0005000000000000000000000000000000000000000000000000000000000000000000000007000000070000000000000000000000000007a000000000000000
0557550000050000000000000000000007000700070007000000000000000000000700000007000000000000000000000000000000000000a000000000000000
577aa7500057500000050000007070000070700000000000000000000007000000070000000000000000000000000000000000000000000aa000000000000000
05a99500057a950000575000000700000000000000000000000700000077700007707700770007707000007000000000000000000000000a0000000000000000
059595000059500000050000007070000070700000000000000000000007000000070000000000000000000000000000000000000000000a7000000000000000
005050000005000000000000000000000700070007000700000000000000000000070000000700000000000000000000000000000000000a7000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000700000007000000000000000000000000000a7a00000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000779a00000000000000
000aa000000aa000000aa000000aa000000aa000000aa00003b77b3003b77b300000000300000000000000000000000000000000000000a9aa00000000000000
00a44a0000a44a0000a44a0000a44a0000a44a00f0a44a0f03b77b3003b77b300300000b00003000000000000000000000000000000000aaaaa0000000000000
004ff400004ff400004ff400004ff400004ff4000f4ff4f003b77b3003b77b300b0030003000b0030000000000000000000000000000079aaaa0000000000000
f047740f0047740000477400ff4774fff047740f0f4774f003b77b3003b77b300000b000b000000b000000777700000000000000000009aaaaa0000000000000
0ff77ff0fff77fff0ff77ff0f7f76f7f7ff77ff700f77f000333333003b33b30000000300030000000000700007000000000000000007a7777a7700000000000
00776770007767000f7667f077776776777767760077677003b77b30033bb330003000b000b000300000700000070000000000000779a700007a700000000000
0766f7600766f7700767f7607766f7676766f76006766f603b7777b303b77b3000b00000000030b00007000f00007000000000000a9a70000407a90000000000
06f7f60007f7767006f7776006f7f67006f7f6000f6776f0b777777b3bb77bb0000000000000b0000007008884007000000aaaaaaaa7000f4f407aa000000000
0000005555000000000000555500000000000055550000000000005555000000000000000000000000070f084f407000aaaaaaaaa7770088f4007aaaaaaaa000
000005bbb7500000000005b77b50000000000577bb5000000000057bb750000000000000000000000007002204007000aaa77a79aaa70f0824007aaa79999aaa
00005bb33b75000000005bb377b50000000057733bb50000000057bbbb7500000000000000000000000700202400700000000a99aaa7002220007aaaa77aaa00
0005555555555000000555555555500000055555555550000005555555555000000000000000000000007000000700000000000099a7002002007aaaa0000000
055d66d666d67550055d66d666d67550055d66d666d67550055d66d666d67550000000000000000000000700007000000000000000aa70000007a90000000000
33333333333bbb3b333333bbb3b33333bbb3b333333333333b3b3b3b3b3b3b3b0000000000000000000000777700000000000000007aa700007aaa0000000000
0566d666d666d6500566d666d666d6500566d666d666d6500566d666d666d650000000000000000000000000000000000000000000007a7777aa700000000000
005dbb6556bbd500005dbb6556bbd500005dbb6556bbd500005dbb6556bbd500000000000000000000000000000000000000000000000aaaaaaa000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099a9a00000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000079a9a00000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007a7000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007a7000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009a000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007a000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000000000000000000000000000000
000880000009a000000000000000000000eee8800000000000aa0000000cccdd0000000000000000000000abbbb0000ccddd0000ee0000000000000000000000
00888800009aaa00000bb0000cd000000eee88880099000000abb00000cccdddd00000000888900000000abbbbbc000cddddd00eee8000000000000000000000
0088899009aaaa00000bc0000ddd0000eee800880099000000bbb0000cccd00dde000008888999000000abbbbbccc00dddddeeeee88000000000000000000000
008899990aaaaa0000bcc0000ddd0000ee80000000990000000bb0000ccd0000ee00008888999990000abb0000ccc00ddd0eeeee888000000000000000000000
00890999aaa0abb000ccc00000dd0000e8888000009aa000000bb0000cd00000ee000088800099a0000bb000000ccd0ddd00eee8088800000000000000000000
0099009aaaa0bbb000ccc00000dee0000888890000aaa00000bbc0000ddd000eee00088890000aa0000bb0000000dd0dde00ee88008900000000000000000000
0099000aaa000bb000ccc00000eee0000008990000aaa00bbbbcc0000ddddeeeee00088900000aaa00bbb0000000dd00ee000880009990000000000000000000
0099000aaa000bbc00ccd00000eee00000009990000aabbbbbccc0000dddeeeee000089900000aaab0bb00000000dd00eee00000009990000000000000000000
0099a000ab0000cc00cdd00000eee00000000990000abbbbb00ccc000dd000ee80000999000000abb0bb0000000ddd00eee0000000099a000000000000000000
009aa000000000cc000ddd000eee0000000009a0000bb000000ccd000de0000888000099900000bbb0bcc00000ddd000ee8000000009aa000000000000000000
000aa000000000ccc00dddeeeee8000890009aa0000bbb000000ddd00eee000088800099aaa00bbb00cccc000ddde000e88000000000aaa00000000000000000
000aaa00000000ccd000deeeee8000099999aa00000bbb000000ddd00eee00008899000aaaaabbbb00ccccddddde0000888000000000aaa00000000000000000
000aab00000000cd00000eeee8000000999aa0000000bc0000000dd000ee0000099900000aabbb00000ccddddde000008880000000000ab00000000000000000
0000bb00000000000000000000000000000000000000cc00000000000000000008880000008008800000ddddd000000008800000880000000000000000000000
00000000000000000000077700000000000000000000000000000000000008000888808888888880000000000000088000000008888800000000000000000000
00000000000000000000777770000000000000000000000000000000000008888089888988998800888008888888888800088669988800000000000000000000
000000000000000000066666000000000000000000000000000000000000088988889aa999aa9806668888989988888866889666a99808800000000000000000
000000000066600000666600000000000000000000000000000000000000088999989a6aaa00a96666a889aaaa9999986689a666aa9888800000000000000000
000000000ddddd0000dd00000000000000000000ddddd000000dddd0000dddd888999add00000adddd889a0dddda0088ddda0ddda0a998800000000000000000
000000000ddddd00000000dddd00dd000000000dddddd00000dddddd000dddddd889a0dddd0000ddd0889adddddd000dddd00ddd00a988000000000000000000
0000000006606660000066666600666000000006666600000666006600000666669a0006660000666099a6600066600066600666600a99800000000000000000
0000000006606660000666666000066000000000066000000660000000000660669a0000660006660aaa066000006600666006666000a9800000000000000000
0000000077700777000777000000077700000000077000007770000000000778889aaa0777770777700077000000770077770077700a98000000000000000000
0000000066600666000660000000066600000000066000006600000000006669999a00006666666600006600666666006666006660a988080000000000000000
0000000066000066000660066000006600000000066600006600000000006688999a0000666666660000666666000000666600066a9980080000000000000000
00000000dd0000dd000dddddd00000dd0000000000dd0000dd0000000000dd8889a00000ddd00ddd00000dddd00000006666000ddd9888880000000000000000
00000000dd000ddd000ddddd000000dd0000000000dd0000dd0000000000dd0089a00000ddd00ddd00000ddd00000d006666000ddda999980000000000000000
0000000666006666000660000000006660066600006666006660066600666600889a000066600066000006666006660006660006660aa9880000000000000000
000000066666666000066600066000666666660066666600066666660066666689a000066660006660000666666660000666666066666a980000000000000000
0000000777777700000777777770000777777000777770000077777000077777889aaa7776670006677aa777777777770777777077777a980000000000000000
00000000777700000000777777000000777700000000000000000000000000000889aaa7066000077700000777000aa007777770777709800000000000000000
__label__
000000000000000000001100000000000000000000000000000000000001111000007b77bbbbbbbbb33300000000000000000000000000000000000000000000
0000000000000000000010100000000000000000000000000000000000002100000077777bbbb7bbbb3b30000000000000000000000000000000000000000000
00000000000000000000100000000000000000000000000000000000000021000007b77bbbbbbbbbbb3330000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000006d000000000000007b7bbbbb7bbb7bbbb330000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000006d10000011311131077bb3bbbbb3bbb3bb330000000000000000000000000000000000000000000
0000000000000000000000000000000070000000000000000d110131113111311107b3b7bbb7bbbbb3bb33000000000000000000000000000000000000000000
0000000000000000000000000000100000777770000000006d1d1011131313111307bb33bbb7bb3bbbb3b0700000000000000000000000000000000000000000
0000000000000000000000000001000007777bb7077031066dd1101113ccc3113107b333bbbbbbb3333330002662000000000000000000000000000000000000
000000000000000000000000000007007777bbbb7bbb0106dd111011cc7cccbb33307b3bbb3333333b3300662222200000006300000000000000000000000000
00000000000000000000000000000000777b7bb3bb33300dd11d10b3cccc7c7333b30bb7bbb73333333006222222106300003100000000000000000000000000
000000000000000000000000000000077b73bbbbbbb333013b333b31ccccccb33b3330bb3bb333b3000102227111003100006300000000000000000000000000
0000000000000000000000000000000777bbbbbb7b333b30b333b333c7ccc733b333b300b3333400b33330117220306066d03100000000000000000000000000
00000000000000000000000000000007777bbb3bbb000000333b333b3c00b33b3330000000004270733b33770770100000000300000000000000000000000000
00000000000000000000000000000077b003bbbbb0000000330033b3300003b33300000003044407300003b3742010000000d000cc0000000000000000000000
00000000000880000009a000000000770000bbbb00eee88000000b3300aa0033300cccdd0009247000000030722000abbbb0000ccddd0000ee00000000000000
0000000000888800009aaa00000bb0000cd007b00eee88880099003300abb00300cccdddd009440008889003b3300abbbbbc000cddddd00eee80000000000000
000000000088899009aaaa00000bc0000ddd0000eee822880099003b00bbb0000cccd11dde004008888999003300abbbbbccc00dddddeeeee880000000000000
00000000008899990aaaaa0000bcc0000ddd0000ee82002200990003003bb0000ccd1001ee00008888999990000abb3333ccc00ddd1eeeee8880000000000000
0000000000894999aaa9abb000ccc00001dd0000e8888000009aa000000bb0000cd10000ee000088824499a0000bb300001ccd0ddd02eee82888000000000000
000000000099049aaaa0bbb000ccc00b00dee0002888890000aaa00000bbc0000ddd000eee00088890004aa0000bb0000001dd0dde00ee880289000000000000
000000000099004aaa903bb000ccc00b00eee0000228990000aaa00bbbbcc0000ddddeeeee00088940000aaa00bbb0077700dd01ee0028820099900000000000
000000000099000aaa000bbc00ccd00b00eee00200029990009aabbbbbccc0000dddeeeee200089900b00aaab0bb300bbb00dd00eee002200099900000000000
000000000099a009ab0003cc00cdd00000eee00000004990000abbbbb31ccc000dd122ee80000999000009abb0bb00b3b00ddd00eee0000000499a0000000000
00000066009aa000930000cc001ddd000eee2000000009a0000bb333300ccd000de0002888000499900000bbb0bcc00000ddd100ee8000000009aa0000000000
00006666004aa000000300ccc00dddeeeee8000890009aa0000bbb000001ddd00eee000288800099aaa00bbb30cccc000ddde000e88001000004aaa000000000
00066663600aaa00003100ccd001deeeee8200099999aa90000bbb000300ddd00eee00008899004aaaaabbbb00ccccddddde2000888001300000aaa000000000
00663666300aab00310100cd10001eeee8200004999aa9003003bc0030001dd002ee0000299900099aabbb33001ccddddde200008880031000009ab000000000
000666663009bb0011100011003002222200b00044499003b300cc00077001100022003004440000099333000001ddddd1200300288001110000093000000000
00663663330033001310100003300777000b30900000003b3300110007770000b0000b330000033000000000bb0011111000b330022001131000000000000000
0063661336300001110003003300777770030944000003b333b00000077bb007bb00b3bb300033b0000000bbbbb00000000b3330000031311100000000000000
0006631333310013100000333006666660033b333b333b33000000070770000b3bb000033b303000000307b7007b000003330033000300111300000000000000
000666633331333100666003006666dd00330033b333b3300000007707000000bb00000003300006660007b0000b300003300003033000013110000000000000
00066633313331100ddddd0000dddd000000000b333b3300ddddd006000dddd0000dddd000000dddddd00700dd0000dd0000dd003300dd001113000000000000
00006333333131100ddddd00001100dddd00dd0033b3300dddddd00600dddddd000dddddd000ddddd110000ddd0000ddd000ddd0000ddd001131000000000000
00006633331111100661666000006666660066600b33300666661000066611660001166666066661100070066600006660001666006661001311100000000000
000063336631110006606660000666666d00d6600333b00dd66d00d0066d00dd0000066d660666d0000000066d0000d66600066666666003b111310000000000
00006336633313007770d777000777ddd0000777003b3300077006007770000003300770dd077700077700077000200777000d777777d00b3113110000000000
0000063631311100666006660006660000b0066600b333b006600300666000003300666000066666666600066002400666000066666600b33331113000000000
000000063331120066d00d660006600660000d6600333b300666000066003b00040066d0000d666666dd0006600042006600300d666660033b31131000000000
0000000063111200dd0000dd000dddddd00300dd003000300ddd0000dd00b0000400dd007700dddddd00000ddd000000dd00b00ddddddd00b331311100000000
0000000001110200dd000ddd000ddddd100b00dd0000000b00dd0000dd0000000000dd007b001ddd0000dd0ddd00000ddd0000ddddddddd0033b111300000000
00000000000000066600666600066111000000666006660000666600666006660066660003b006666006660166666666660006666116666600b3113100000000
00000000131040066666666d00066600066000666666660066666600d66666660066666600300d6666666d00666666666d006666d00d66660033131110000000
0000000031042007777777d000077777777000d777777d0077777d000d77777d00d77777003300d77777d000dd77777dd00077770000d77d0033b11130000000
0000000311042006777766003006777777600006777760006666600b00666660000666660000300666660030006666600000677600b00660033b311311000000
000000011133330066660003330066666600770066660030000000b3300000000900000003b30000000000b30000000003b006600bbb0000b0b3333111000000
0000000000133b30000000333b30000000077bb000000b3300000b333b0000033b3000003b0077700000b3033b0000033b330000b7bb300333033b1113000000
00006666660000030000b333b3330000007777bb0000bbb3b303b333b333b333b333b333b07777b77bbb3b30b333b333b33070073bbbbbbb3330b31131100000
0666636633666360333b333b333b33307b77bbbbbbbbbbb3330b333b333b333b333b333b07777b7b33bbbb30333b333b3330777bbbbbb7b333b3033311100000
636666633333333303b333b333b33307b7bbbbb7bbb7bbbb330333b333b333b333b333b077b777bb3bb7bbb303b333b333b07777bbb3bbbb333303b111300000
666633331313333310333b333b333b077bb3bbbbb3bbb3bb33033b333b333b333b333b33077777bbbbbbbb3330333b333b077b7b3bbbbbb33b330b3113100000
66333333333336311033b333b333b3307b3bbbbbbbbbbb3bb330b333b333b333b333b33077b77bbbb3bbbb3b3033b333b07777bbbbbbbb333330b33131110000
3663331331333331110b333b333b33307bb33bbb7bb3bbbb3b30333b333b333b333b33307b773bb7bbbbb333303b333b307b7b7bbb7b3bb3b330333b11130000
6333313363333311111033b333b333b07b333bbbbbbb3333330333b333b333b333b333b3077b3bbbb3bb3b3330b333b30777bbbbbbbbbbb333b033b311310000
331333333333333111103b333b333b3307b3bbb3333333b330333b333b333b3737333b3307777bbbb3bbb33b30333b33077bbb3bbb3bb33b77770b3313110000
63333333363333331110b333b333b333b0bbbbbb733333330333b333b333b3707073b3330777bbb3bbb333333033b33307bb7bbb33333b3777bbb03331110000
3333363133133633110b333b333b333b330bb3bb333b3000333b333b333b37040407333b307bbbbbb3b33b33033b333b07bbbbbb33b3337b7bbb330b11130000
3333331333333331110333b333b333b333b00b33334003b333b333b333b333704f0733b33077bbbb33333330000333b3077bb3bbb3333b77bb3b330331311000
636333333333111111103b333b333b003b33300004220b333b333b333b333b70ff073b33307bbb77b333030777703b3307b3bbbbbb32247bb7b3330333111000
63333631331111311110b333b333b0760333b3304440b333b333b333b333b7082f07b333b07bb77bbb3b007bbbbb0333b07b3373b334222b3b333303b1113000
6131333331311111110b333b333b076d033b33309240333b333b333b333b70ff88f0733b3307b7b3b332007bb3bb303b3300bb3bbb3b20033333b03b31131000
666631111111111100b333b333b306dd03b333b0944203b333b333b333b33700220733b333b007bbb334203b7bb330b333b3073333334200000003b331311000
66333111111111103b333b333b3076d6d0333b0944220b333b333b333b33702202073b333b33307b333422b3b33330333b3330b33b4442033b333b3333111000
6313111111111110b333b333b307766dd033b333b333b333b333b333b333b7000207b333b333b3033304200333330333b333b30000044203b333b333b1113000
363113011101110b333b333b330766ddd03b333b333b333b333b333b333b3377707b333b333b3330000420300000333b333b333b3309420b333b333b31131000
33131112210000b333b333b333066dd6d0b333b333b333b333b333b333b333b337b333b333b333b3309420b333b333b333b333b33309442033b333b331311000
1111100211033b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b3309440b333b333b333b333b33309442203b333b3333111000
000001021103b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b33309422033b333b333b333b333b333b333b333b333b1113000
00001102210b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b31131000
00001104211033b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b331311000
0000104211103b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b3333111000
00003111b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b1113000
00000113133b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b11130000
0000013113b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b311310000
000003111b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b333b3313110000
000001113333b333b333b333b300b33000300030003300330033b33300000033b33000330033b33300300030003000300033b333b333b333b333b33331110000
00000113133b333b333b333b307603077707770777007700770b33007777700b33077700770b33307707770777077707770b333b333b333b333b333b11130000
0000003111b333b333b333b3076d0070007000700077007700703007000007033070007700703307007000700070007000703000300333b333b333b111310000
0111110003333b333b333b3306dd0070707070707770777077d000700707007030d707707070007077d707707070707707d0077707703b333b333b3113100000
101011111003b333b333b33076d6d07000700770077000700070707000700070b30707707070707000770770007007d70707777777b30333b333b33131100000
011100000010333b333b3307766dd0707770707077d770777070b0700707007033070770707070d770770770707070770707b77bbb3b303b333b333311100000
10000001000003b333b3330766ddd0707d7070700070077007d070d7000007d03307077007d0b07007d7077070707077070b7b33bbbb30b333b3333111300000
00000000000000333b333b066dd6d0d7d0d7d7d777d77dd77d00b30d77777d033b0d7dd77d0bb0d77d0d7dd7d7d7d7dd7d07bb3bb7bbb3033b333b1113000000
0000000000000033b333b333b333b00d0d0d0d0ddd0dd00dd0307b00ddddd033b330d00dd0bbb70dd030d00d0d0d0d00d077bbbbbbbb3330b333b31131000000
001000000000000b333b333b333b3060d6600030003003300330330b0000033b330707700bbbbbb00b33003030303077077bbbb3bbbb3b30333b311311000000
000000010000000333b333b333b30766766dd0b333b333b333b3330330b333b3307b7bbbbb7bbb7bbbb330b333b3307b773bb7bbbbb3333033b3313110000000
00000100000000033b333b333b3306d76d6dd0333b333b333b333b333b333b333077bb3bbbbb3bbb3bb330333b333b077b3bbbb3bb3b33303b33131110000000
1000000000000033b333b333b33306d6dd6dd033b333b333b333b333b333b333b307b3bbbbbbbbbbb3bb3303b333b107777bbbb3bbb33b30b333311100000000
000000000000000b333b333b333b333b333b333b333b333b333b333b333b333b3307bb33bbb7bb3bbbb3b30b333b1c0777bbb3bbb3333330333b111300000000
010000000000000333b333b33300000033b333b333b333b333b333b333b333b33307b333bbbbbbb3333330b333b1cc707bbbbbb3b33b330333b1113100000000
00000000000000333b333b300066666600000b333b333b333b333b333b333b333b307b3bbb3333333b330b333b33ccc077bbbb33333330000b31131000000000
0000000000000113b333b3066663663366636033b333b333b333b333b333b333b3330bbbbbb733333330b333b31cccc07bbb77b3330307777011311000000000
0000000000030003333b3063666663333333330b333b333b333b333b333b333b333b30bb3bb333b3000b333b333c7bc07bb77bbb3b007bbbbb03110000000000
000000000000111033b30666663333131333331033b333b333b333b333b333b333b33300b33334000300000333bb31cc07b7b3b332007bb3bb30110000000000
00000000001110000b33066633333333333631103b333b3330003b333b333b333b333b330000422030aaaaa03b3333b73007bbb334203b7bb330100000000000
00001000011101000333063663331331333331110333b33307760333b333b333b333b333b30444030a00000a0333b333b3307b333422b3b33330000000000000
0000010001100000013b06633331336333331111103b3330776d003b333b333b333b333b33092400a000a000a03b333b333b0333042003333303000000000000
000001001100000001330633133333333333311110b333b076dd760333b333b333b333b333094420a00a4a00a0b333b333b33000042030000030000000000000
000001000000000013110663333333363333331110333b3066d66d033b333b333b333b3330944220a00aaa00a0333b333b333b30942033111300000000000000
00000100000000013111063333360033003003100030000700706dd00033b333b333b333b333b3304a00000a4033b333b333b3094403b1113100000000000000
00001000000000001113063333309900990990099909990099090dd0990b033b333b333b333b333b04aaaaa4033b333b333b3309422011131000000000000000
00000000000000000131106363090099009009900090009900909009009090b333b333b333b333b33044444033b333b333b333b333b111310000000000000000
00000000000000000011106330909990909090990990909090909090992909033b333b333b333b333b0000033b333b333b333b333b1113100000000000000000
0000000000000000001130613090929090909099099009909090909000929203b333b333b333b333b333b333b333b333b333b333b11131100000000000000000
000000000000000000031066609099909090909909909090909099299099090b333b3300000b333b3300000b333b3300000b333b111311000000000000000000
000000000000000000000666302900900990909909909090099000900922920333b330aaaaa033b330aaaaa033b330aaaaa033b1113110000000000000000000
00000000000000000000066313029929922929229229292992299929920020333b330a00000a0b330a00000a0b330a00000a0b11131100000000000000000000
0000000000000000000006363110220220020200200202022002220220330333b330a000aa00a030a00aaa00a030a00aa000a011311000000000000000000000
000000000000000000000633131100200000303b0330004003300030033b333b3330a00a4a00a030a00a4a00a030a00a4a00a013110000000000000000000000
0000000000000000000000111110021103b333b333b30f4403b333b033b333b333b0a000aa00a0b0a000a000a0b0a00aa000a031100000000000000000000000
000000000000000000000000000102110b333b333b333b333b333b070b033b333b304a00000a40304a00000a40304a00000a4011000000000000000000000000
000000000000000000000000000102210333b333b333b333b333b07b0070b333b33304aaaaa4033304aaaaa4033304aaaaa40100000000000000000000000000
00000000000000000000000000000421101b333b333b333b333b07b307b0333b333b30444440333b30444440333b304444401000000000000000000000000000
00000000000000000000000000004211103113b333b333b333b007b37b3033b333b33300000333b33300000333b3110000010000000000000000000000000000
00000000000000000000000000000001131113333b3330033b0d10307b303b333b333b333b333b333b333b333b31131113000000000000000000000000000000
0000000000000000000000000000000031113111b3330d10b3010037b303b333b333b333b333b333b333b333b111311130000000000000000000000000000000
0000000000000000000000000000000000131113111b0100000d1037b30b333b333b333b333b333b333b33131113111000000000000000000000000000000000
000000000000000000000000000000000001113111310d10d101003b330333b333b333b333b333b333b311311131110000000000000000000000000000000000
000000000000000000000000000000000000031003010100100010300b300b333b333b333b333b33331113111311000000000000000000000000000000000000
00000000000000ddd0ddd0ddd00dd0ddd0d0d00dd0d00d10d0dd000dd00dd033b333b333b333b1113111311131000000000000000000000d000dd00d0d0ddd00
00dd00d0d0000d000d000d000dd00d000d0d0dd00d0d00000d00d0d00dd00d0b333b333b11131113111311100000000ddd00dd0ddd0000d0d0d00dd0d0d000d0
0d00dd0d0d0001d0dd0d0d0d0d0ddd0ddd0d0d0d0d0d01300d0d0d0d0d0dd101113111311131113111311000000000d000dd00d000d000d0d0d0d0d0d0d0d0d0
0d00dd000d0000d0dd00dd000d000d00dd0d0d0d0d0d00000d0d0d0d0d0dd011131113111311131113000000000000d00dd0d0d0d0d000d0d0d0d0d000d0d0d0
0d0d0ddd0d0000d0dd0d0d0d0ddd0d0ddd000d0d0d0dd0dddd0d0d0d0d0d0d01311131113111310000000000000000d0d1d0d0d00d1000d0ddd0d0ddd0d0d0d0
0d000d000d0000d0dd0d0d0d0d00dd000dd0dd00dd000d000d000d00dd000d03111311130000000000000000000000d0d0d00dd0d0d000d000d000d1d0d000d0
01ddd1ddd100001d11d1d1d1d1dd11ddd11d11dd11ddd1ddd1ddd1dd11ddd1000000000000000000000000000000001d101dd11d1d10001ddd1ddd101d1ddd10
00111011100000010010101010110011100100110011101110111011001110000000000000000000000000000000000100011001010000011101110001011100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000f3430d645000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001b35321255281552814528135281252811528115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001d3542b5532d5550f6451b605036250f6051b615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001a3531c1551d4541f25421355234542415524255242452423524225242152421500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001d3332d055395450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000275252e5252e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b000011353073530f6450f63203611000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010e00000531200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800001032304345056452921500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b000011343073430f6350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001a5551c0551d5551f05521555230452353523025235152301518500185002450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000107531c0550f04510035286251c0550f045100351c025047531c0551c045286251c0550f04510035107531c0550f04510035286251c0550f045100351c02504753100551004528625100552762528745
01100000107531c0551d0451f035286251c0551d0451f0351c025047531c0551c0451c0551c0550f04510035107531c0551d0451f035286251c0551d0451f0351c02504753100551004528625100552762528745
01140020047331d5351f52521515105131d5151f51521515047331d5351f52521515106151d5151f51521515047331d5351f52521515105131d5151f51521515047331d5351f52521515106151d5151f51521515
011000001c553215441f5331d5241c553215441f5341d5241c553215441f5341d5241c553215441f5331d5241c553215441f5331d5241c553215441f5341d5241c553215441f5331d5241c553215441f5331d524
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 10424344
02 11424344
01 10124344
02 11134344
03 12424344

