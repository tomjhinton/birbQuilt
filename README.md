# birbQuilt


For @sableRaph's weekly Creative Coding Challenge. The Challenge topic was 'Quilt'.

One of those where I had an idea, it didnt really work and the main thing I've learnt is limitations. (I have not learnt a thing and will just try it again as soon as I forget it was hard)

# Blender Bit.
- Kind of wanted to test out making a [Skybox](https://en.wikipedia.org/wiki/Skybox_(video_games))
- I'm assuming there's a way you can do it nice and simply in Blender
- I don't know what it is.
- I'm aware the perspective stuff is wrong.
- Was gonna go back and fix it.
- We all know I will not have gone back and fixed it.

# Three Bit.
- So here's how to set a [skybox in Three ](https://r105.threejsfundamentals.org/threejs/lessons/threejs-backgrounds.html)
- Wanted to do some sorta proper cloth simulation.
- Plan was to use cannon.es
- Hey, there's a [codrops article](https://tympanus.net/codrops/2020/02/11/how-to-create-a-physics-based-3d-cloth-with-cannon-js-and-three-js/)
- Based on this [example](https://pmndrs.github.io/cannon-es/examples/threejs_cloth) where you use a ball to simulate wind.
- Hey, I've made it [before](https://neurot468.herokuapp.com/#/), that will take a sec to load because of the database going to sleep because nobody looks at it.
- Little generative thing done server side, changes once an hour
- As with anything generative, if it looks good, that was me, if was bad that's the algorithms fault.
- Either I'm dumb (strong possibility) or they've moved some of where vertices are stored in three since those things were made.
- Didn't have long to mess around with it.
- Some muttering and frowning ensued.
- Cheated it in the vertex shader.
- It's windy in the cabin because it's badly built.
- Or ghosts, probably some cabin ghost.
- Actually that explains why it's just hanging there.
- Definitely cabin ghosts.



# Shader bit.
- My standard throw Math.random() into the uniforms and call it generative.
- Bunch of if statements so yeah, this aint performative
- There's less variation than I'd like tbh



#Other
- [Very cool and useful Font](https://www.dafont.com/seeds.font)

So yeah, skybox is functional but doesnt look good, cloth ripple is functional but thats about it and shaders are functional but unperformant and lacking in variety.
