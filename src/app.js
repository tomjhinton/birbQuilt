import './style.scss'
import * as THREE from 'three'
// import * as dat from 'lil-gui'
import gsap from 'gsap'
import * as Tone from 'tone'

import vertexShader from './shaders/vertex.glsl'
import fragmentShader from './shaders/fragment.glsl'

import * as CANNON from 'cannon-es'
import CannonDebugger from 'cannon-es-debugger'


import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'







const canvas = document.querySelector('canvas.webgl')

const scene = new THREE.Scene()

const world = new CANNON.World({
  gravity: new CANNON.Vec3(0, -9.82, 0) // m/s²
})




  const shaderMaterial = new THREE.ShaderMaterial({
    vertexShader: vertexShader,
    fragmentShader: fragmentShader,
    transparent: true,
    depthWrite: true,
    clipShadows: true,
    wireframe: false,
    side: THREE.DoubleSide,
    uniforms: {
      uFrequency: {
        value: new THREE.Vector2(10, 5)
      },
      uTime: {
        value: 0
      },
      uValueA: {
        value: Math.random()
      },
      uValueB: {
        value: Math.random()
      },
      uValueC: {
        value: Math.random()
      },
      uValueD: {
        value: Math.floor(Math.random() * 12) +5
      },
      uValueAlpha: {
      value: 1
    }
    }
  })




      let geometry = new THREE.PlaneGeometry(4, 4, 200, 200)

      let mesh = new THREE.Mesh(geometry, shaderMaterial)





scene.add(mesh)



  const loader = new THREE.CubeTextureLoader();
  const texture = loader.load([
    'untitled.jpg',
    'untitled1.jpg',
    'untitled2.png',
    'untitled3.jpg',
    'untitled2.png',
    'untitled1.jpg'
  ]);
  scene.background = texture;



//Lights
const directionalLight = new THREE.DirectionalLight('#ffffff')
directionalLight.position.set(1,1,0)
scene.add(directionalLight)
/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

let titular = document.getElementById('titular')

titular.addEventListener('click', function (e) {
  shaderMaterial.uniforms.uValueA.value = Math.random()
  shaderMaterial.uniforms.uValueB.value = Math.random()
  shaderMaterial.uniforms.uValueC.value = Math.random()
  shaderMaterial.uniforms.uValueD.value = Math.floor(Math.random() * 12) +5

});


/**
 * Camera
 */

 // group

 const cameraGroup = new THREE.Group()
 scene.add(cameraGroup)
// Base camera
const camera = new THREE.PerspectiveCamera(35, sizes.width / sizes.height, 0.1, 100)
camera.position.z = 6
scene.add(camera)


// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true
controls.maxPolarAngle = Math.PI / 2 - 0.1
controls.enableZoom = false;

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    alpha: true
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

const raycaster = new THREE.Raycaster()
const mouse = new THREE.Vector2()


/**
 * Animate
 */
const clock = new THREE.Clock()
let previousTime  = 0

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime()
    const deltaTime = elapsedTime - previousTime
    previousTime = elapsedTime





  world.step(1/60, deltaTime, 3)

    // Update controls
    controls.update()

    shaderMaterial.uniforms.uTime.value = elapsedTime
    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()
