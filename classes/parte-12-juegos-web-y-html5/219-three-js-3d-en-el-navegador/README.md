# Clase 219 — Three.js: 3D en el navegador

> Parte: **12 — Juegos web y HTML5** · Fuente: *Documentación oficial de Three.js (threejs.org)*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

**Three.js** es la biblioteca más usada para 3D en el navegador: envuelve WebGL con una API cómoda de escenas, cámaras, mallas y luces. En esta clase montarás las tres piezas imprescindibles de cualquier aplicación 3D web: una **`Scene`** (el mundo), una **`PerspectiveCamera`** (el punto de vista) y un **`WebGLRenderer`** (que dibuja en el canvas). Sobre ellas colocarás una **`Mesh`** —geometría más material— iluminada por una **luz**, y la animarás en un bucle `renderer.render(scene, camera)`.

Al terminar tendrás un cubo iluminado que rota, con una cámara colocada en el espacio, y sabrás cómo se extiende esto para cargar modelos **glTF** y añadir controles de órbita. Este es el cimiento de cualquier juego o experiencia 3D en la web.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Crear `Scene`, `PerspectiveCamera` y `WebGLRenderer` y conectarlos.
2. Construir una `Mesh` a partir de geometría y material, y añadirla a la escena.
3. Iluminar la escena con luz ambiental y direccional.
4. Animar la malla en un bucle con `requestAnimationFrame` y `renderer.render`.
5. Describir cómo se carga un modelo glTF y se añaden controles de cámara.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Scene | Contenedor de todo lo visible en 3D. |
| 2 | PerspectiveCamera | Define el punto de vista y la perspectiva. |
| 3 | WebGLRenderer | Dibuja la escena en el canvas vía GPU. |
| 4 | Geometry + Material = Mesh | La unidad visible del mundo 3D. |
| 5 | Luces | Sin luz, los materiales estándar salen negros. |
| 6 | Bucle de render | Redibuja cada cuadro para animar. |
| 7 | Modelos glTF | Formato estándar para importar assets 3D. |
| 8 | OrbitControls | Permite girar la cámara con el ratón. |

## 📖 Definiciones y características

- **Scene**: raíz que contiene mallas, luces y cámaras. Clave: lo que no está en ella no se dibuja.
- **PerspectiveCamera**: cámara con FOV, aspecto y planos near/far. Clave: emula la visión humana con perspectiva.
- **WebGLRenderer**: objeto que rasteriza la escena en un canvas. Clave: su `domElement` es el lienzo que insertas en la página.
- **Geometry**: vértices y caras de una forma (caja, esfera). Clave: define la forma, no el color.
- **Material**: cómo reacciona la superficie a la luz. Clave: `MeshStandardMaterial` necesita luz para verse.
- **Mesh**: geometría + material posicionables. Clave: el objeto 3D concreto que ves.
- **Light**: fuente de iluminación (ambiental, direccional, puntual). Clave: da volumen y realismo.
- **glTF**: formato abierto para modelos 3D. Clave: se carga con `GLTFLoader`, ideal para assets externos.

## 🧰 Herramientas y preparación

Usaremos Three.js vía CDN con un **import map** para poder importar el módulo por nombre (<https://unpkg.com/three>). Sirve por HTTP con `python -m http.server`, ya que los módulos ES no funcionan bajo `file://`. La documentación y el manual "Creating a scene" están en <https://threejs.org/docs/>.

Crea `three-cubo/` con un único `index.html` que contenga el HTML y el módulo. No hace falta empaquetador: aprovecharemos los módulos nativos del navegador.

## 🧪 Laboratorio guiado

Montarás un cubo iluminado que rota con una cámara colocada frente a él.

1. Crea `index.html` con un import map y un `<script type="module">`:

```html
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Cubo 3D</title>
  <style>body{margin:0;overflow:hidden}</style>
  <script type="importmap">
    { "imports": { "three": "https://unpkg.com/three@0.160.0/build/three.module.js" } }
  </script>
</head>
<body>
  <script type="module" src="juego.js"></script>
</body>
</html>
```

2. En `juego.js` crea la escena, la cámara y el renderer, e inserta el canvas:

```javascript
import * as THREE from 'three';

const escena = new THREE.Scene();
escena.background = new THREE.Color(0x101828);

// Cámara: FOV 60°, aspecto de la ventana, planos de recorte near/far.
const camara = new THREE.PerspectiveCamera(60, innerWidth / innerHeight, 0.1, 100);
camara.position.set(0, 1.5, 4);   // Un poco arriba y hacia atrás.
camara.lookAt(0, 0, 0);

const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(innerWidth, innerHeight);
document.body.appendChild(renderer.domElement);
```

3. Crea la malla del cubo (geometría + material) y añádela a la escena:

```javascript
const geometria = new THREE.BoxGeometry(1, 1, 1);
const material = new THREE.MeshStandardMaterial({ color: 0x4ade80 });
const cubo = new THREE.Mesh(geometria, material);
escena.add(cubo);
```

4. Añade iluminación: una luz ambiental suave y una direccional que dé volumen:

```javascript
escena.add(new THREE.AmbientLight(0xffffff, 0.4));
const sol = new THREE.DirectionalLight(0xffffff, 1.2);
sol.position.set(3, 5, 2);
escena.add(sol);
```

5. Escribe el bucle de render con `requestAnimationFrame`, rotando el cubo cada cuadro:

```javascript
function animar() {
  requestAnimationFrame(animar);
  cubo.rotation.x += 0.01;
  cubo.rotation.y += 0.015;
  renderer.render(escena, camara);   // Redibuja la escena desde la cámara.
}
animar();
```

6. Haz la ventana redimensionable actualizando cámara y renderer:

```javascript
addEventListener('resize', () => {
  camara.aspect = innerWidth / innerHeight;
  camara.updateProjectionMatrix();
  renderer.setSize(innerWidth, innerHeight);
});
```

7. Sirve la carpeta (`python -m http.server 8000`) y abre <http://localhost:8000/>. Verás un cubo verde iluminado girando sobre fondo oscuro, que se adapta al tamaño de la ventana.

Ya tienes la base 3D. Para cargar un modelo real, importarías `GLTFLoader` desde `three/addons/loaders/GLTFLoader.js` y usarías `loader.load('modelo.gltf', (gltf) => escena.add(gltf.scene))`.

## ✍️ Ejercicios

1. Cambia la geometría a una esfera (`SphereGeometry`) y observa cómo la luz la modela.
2. Añade un segundo cubo en otra posición con distinto color.
3. Cambia el material a `MeshBasicMaterial` y explica por qué deja de necesitar luz.
4. Mueve la luz direccional con el tiempo (seno) y describe el efecto.
5. Añade `OrbitControls` (import desde `three/addons/controls/OrbitControls.js`) para girar la cámara con el ratón.
6. Coloca la cámara más lejos y ajusta el `far` si el objeto desaparece.

## 📝 Reto verificable

Crea una escena con al menos tres mallas distintas (por ejemplo cubo, esfera y cilindro) de colores diferentes, iluminadas por una luz ambiental y una direccional, todas rotando a velocidades distintas, con la cámara controlable por el ratón mediante OrbitControls.

**Criterio de aceptación**: al abrir la página se ven las tres mallas iluminadas rotando, el ratón orbita la cámara alrededor de la escena, y la ventana se redimensiona sin deformar la imagen; sin errores en consola.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| Pantalla negra total | Falta luz o la cámara mira a otro lado. Añade luces y usa `camara.lookAt(0,0,0)`. |
| "Failed to resolve module specifier 'three'" | Falta el import map o sirves por `file://`. Añade el import map y sirve por HTTP. |
| El cubo no rota | No llamas a `renderer.render` dentro del bucle. Verifica que `animar` se reinvoque con rAF. |
| La imagen se ve estirada | No actualizas `aspect` al redimensionar. Recalcula y llama a `updateProjectionMatrix`. |
| El objeto sale recortado o invisible | Está fuera del rango near/far o detrás de la cámara. Ajusta posición y planos de recorte. |

## ❓ Preguntas frecuentes

**❓ ¿Three.js es un motor de juego?** No exactamente: es una biblioteca de render 3D. Aporta el dibujo y la escena; la lógica de juego, física y audio los añades tú o con librerías complementarias.

**❓ ¿Por qué mi material sale negro?** Los materiales tipo `Standard` o `Phong` necesitan luz. Añade al menos una luz o usa `MeshBasicMaterial`, que no la requiere.

**❓ ¿Qué formato de modelo uso?** glTF/GLB es el recomendado por su eficiencia y soporte oficial mediante `GLTFLoader`.

**❓ ¿Necesito empaquetador (bundler)?** No para aprender: con un import map y módulos ES nativos basta. Para producción, un bundler ayuda a optimizar y versionar dependencias.

## 🔗 Referencias

- Three.js — Creating a scene: <https://threejs.org/docs/index.html#manual/en/introduction/Creating-a-scene>
- Three.js — Documentación: <https://threejs.org/docs/>
- Three.js — Loading glTF models: <https://threejs.org/docs/index.html#manual/en/introduction/Loading-3D-models>
- MDN — Getting started with WebGL: <https://developer.mozilla.org/es/docs/Web/API/WebGL_API/Tutorial/Getting_started_with_WebGL>

## ➡️ Siguiente clase

[Clase 220 - WebGL y el pipeline gráfico web](../220-webgl-y-el-pipeline-grafico-web/README.md)
