# Clase 215 — Exportar Godot a HTML5 y WebAssembly

> Parte: **12 — Juegos web y HTML5** · Fuente: *Documentación de Godot 4 — Exporting for the Web*
> ⏱️ Duración estimada: **75 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Godot 4 compila tu juego a **WebAssembly** y lo envuelve en HTML+JS para correr en el navegador. En esta clase aprenderás el flujo completo: instalar las **plantillas de exportación** (export templates), crear un preset **Web**, exportar a una carpeta y servir el resultado por **HTTP**. Verás por qué no basta con abrir el `index.html` y por qué, si tu juego usa hilos, el navegador exige las cabeceras **COOP/COEP** (Cross-Origin-Opener-Policy y Cross-Origin-Embedder-Policy).

También conocerás los límites reales de la exportación web: el tamaño de descarga (el runtime pesa varios MB), el audio que solo arranca tras interacción del usuario y la ausencia de ventanas nativas del sistema. Al final tendrás un proyecto Godot corriendo en `http://localhost` servido con las cabeceras correctas.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Instalar las plantillas de exportación web de Godot 4.
2. Crear un preset de exportación **Web** y generar los archivos de salida.
3. Explicar por qué el juego debe servirse por HTTP y no por `file://`.
4. Servir la exportación con un servidor que envíe cabeceras COOP/COEP.
5. Identificar tres limitaciones de la plataforma web (tamaño, audio, ventanas).

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Plantillas de exportación | Sin ellas Godot no puede generar el binario web. |
| 2 | Preset Web y salida | Define qué archivos se producen y dónde. |
| 3 | Servir por HTTP | El WASM y los recursos no cargan bajo `file://`. |
| 4 | Cabeceras COOP/COEP | Habilitan `SharedArrayBuffer` y los hilos. |
| 5 | Tamaño de descarga | El runtime pesa; afecta el tiempo de primera carga. |
| 6 | Audio tras interacción | El navegador bloquea el audio hasta un gesto del usuario. |
| 7 | Sin ventanas nativas | Diálogos del SO y algunas APIs no existen en web. |
| 8 | Modo hilos vs sin hilos | Hilos rinden mejor pero exigen COOP/COEP y hosting compatible. |

## 📖 Definiciones y características

- **Export templates**: binarios precompilados de Godot para cada plataforma. Clave: se instalan una vez por versión del editor.
- **Preset de exportación**: configuración guardada (plataforma, opciones, archivo destino). Clave: reutilizable para reexportar rápido.
- **WebAssembly**: formato binario al que Godot compila su motor y tu juego. Clave: corre a velocidad casi nativa en el navegador.
- **COOP (Cross-Origin-Opener-Policy)**: cabecera que aísla el contexto de navegación. Clave: requisito para `SharedArrayBuffer`.
- **COEP (Cross-Origin-Embedder-Policy)**: cabecera que exige recursos con permiso cruzado. Clave: junto a COOP habilita hilos.
- **SharedArrayBuffer**: memoria compartida entre hilos. Clave: Godot la necesita para el modo *threads*.
- **Modo sin hilos**: exportación que no usa hilos y evita COOP/COEP. Clave: más fácil de alojar, algo menos rendidora.
- **`index.html` generado**: página que carga el WASM y arranca el juego. Clave: es el punto de entrada servido por HTTP.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** (versión estándar) y **Python 3** para servir localmente. En Godot ve a **Editor → Manage Export Templates** y pulsa **Download and Install** para bajar las plantillas de tu versión exacta (deben coincidir con el editor). La documentación oficial está en <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html>.

Como el servidor `python -m http.server` no envía COOP/COEP, usaremos un pequeño script de servidor propio para el modo con hilos. Ten un proyecto Godot simple listo (por ejemplo el plataformas del curso o una escena con un sprite que se mueva).

## 🧪 Laboratorio guiado

Exportarás un proyecto Godot a web y lo servirás con las cabeceras correctas.

1. Abre tu proyecto en Godot y asegúrate de que tiene una **Main Scene** definida y corre bien con F5.

2. Instala plantillas si no lo hiciste: **Editor → Manage Export Templates → Download and Install**.

3. Ve a **Project → Export**. Pulsa **Add… → Web**. Si aparece un aviso amarillo sobre plantillas, resuélvelo antes de seguir.

4. Crea una carpeta de salida `web/` junto al proyecto. En el preset, en **Export Path**, elige `web/index.html`. Deja **Export With Debug** desmarcado para la versión final.

5. Pulsa **Export Project** (no "Export PCK"). Godot generará varios archivos en `web/`: `index.html`, `index.js`, `index.wasm`, `index.pck` y auxiliares.

6. Prueba primero el modo simple. Sirve la carpeta con Python:

```bash
cd web
python -m http.server 8000
```

7. Abre <http://localhost:8000/>. Si tu exportación **no** usa hilos, el juego cargará (una barra de progreso y luego la escena). Si usa hilos, la consola mostrará un error sobre `SharedArrayBuffer`: eso significa que faltan las cabeceras COOP/COEP.

8. Para servir con esas cabeceras, crea `servidor.py` **fuera** de `web/` con este contenido:

```python
# Servidor local que añade las cabeceras COOP/COEP requeridas por los hilos.
import http.server, socketserver

PUERTO = 8000

class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        super().end_headers()

with socketserver.TCPServer(("", PUERTO), Handler) as httpd:
    print(f"Sirviendo en http://localhost:{PUERTO}/ con COOP/COEP")
    httpd.serve_forever()
```

9. Ejecútalo desde dentro de `web/` para que sirva esos archivos:

```bash
cd web
python ../servidor.py
```

10. Recarga <http://localhost:8000/>. Ahora el navegador permite `SharedArrayBuffer` y la exportación con hilos arranca sin errores. Haz clic en el juego: notarás que el audio recién suena tras esa primera interacción, por la política del navegador.

Ya tienes tu juego Godot corriendo en el navegador servido correctamente.

## ✍️ Ejercicios

1. Exporta el mismo proyecto en modo *debug* y compara el comportamiento y los mensajes en consola.
2. Mide el tamaño total de la carpeta `web/` y anota cuánto pesa `index.wasm`.
3. Cambia el puerto del servidor a 5500 y ábrelo.
4. Añade un sonido al juego y verifica que solo suena tras hacer clic en el canvas.
5. Sirve con `python -m http.server` una exportación con hilos y describe el error exacto de la consola.
6. Personaliza el título de la pestaña en las opciones del preset Web y reexporta.

## 📝 Reto verificable

Exporta un proyecto Godot con al menos un objeto que se mueva por input del jugador y un sonido, sírvelo con el `servidor.py` que envía COOP/COEP, y confirma que corre en el navegador con audio funcional tras interacción.

**Criterio de aceptación**: en `http://localhost:8000/` el juego carga sin errores de `SharedArrayBuffer`, responde al input y reproduce el sonido tras el primer clic; la consola no muestra errores rojos.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "SharedArrayBuffer is not defined" | Faltan COOP/COEP. Sirve con `servidor.py` que añade ambas cabeceras. |
| Aviso amarillo "export templates" | No están instaladas o no coinciden con la versión. Instálalas desde Manage Export Templates. |
| Pantalla en blanco al abrir `index.html` | Abriste por `file://`. Sírvelo por HTTP desde la carpeta `web/`. |
| El audio no suena nunca | El navegador exige un gesto del usuario. Añade un clic inicial que reanude el audio. |
| Descarga muy lenta o pesada | El runtime WASM pesa. Exporta sin debug y considera comprimir/gzip en el hosting. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué mi exportación pesa varios MB?** Incluye el motor de Godot compilado a WASM. Es normal; la versión de release sin debug es la más ligera.

**❓ ¿Necesito siempre COOP/COEP?** Solo si exportas con hilos. En modo sin hilos el juego funciona con un servidor HTTP simple, a costa de algo de rendimiento.

**❓ ¿Puedo alojarlo en cualquier hosting?** Para el modo con hilos, el hosting debe permitir enviar COOP/COEP. GitHub Pages no las envía; itch.io ofrece una opción de "SharedArrayBuffer" en la subida.

**❓ ¿Funcionan todas las funciones del juego?** No todas: diálogos de archivo nativos, algunas APIs del SO y ventanas múltiples no existen en web. Diseña pensando en esas ausencias.

## 🔗 Referencias

- Godot Docs — Exporting for the Web: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html>
- Godot Docs — Export templates: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html>
- MDN — Cross-Origin-Embedder-Policy: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Embedder-Policy>
- MDN — SharedArrayBuffer: <https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer>

## ➡️ Siguiente clase

[Clase 216 - JavaScript para juegos: el bucle y Canvas](../216-javascript-para-juegos-el-bucle-y-canvas/README.md)
