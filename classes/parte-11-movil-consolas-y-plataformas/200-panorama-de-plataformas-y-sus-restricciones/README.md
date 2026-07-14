# Clase 200 — Panorama de plataformas y sus restricciones

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Exporting projects)*
> ⏱️ Duración estimada: **60 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Antes de tocar una sola opción de exportación conviene entender el terreno: un mismo proyecto de Godot 4 puede correr en PC, móvil, web y consola, pero cada destino impone reglas distintas de entrada, potencia, distribución y certificación. Elegir plataformas objetivo tarde en el desarrollo suele obligar a rehacer UI, controles y presupuesto de rendimiento.

En esta clase construimos un mapa mental de las plataformas y sus restricciones, y aprendemos a tomar **decisiones tempranas** de portabilidad: qué input soporta cada destino, cuánta GPU/CPU tienes disponible, qué tienda te distribuye y qué proceso de aprobación o certificación deberás pasar. El laboratorio produce una tabla comparativa que guiará el resto de la Parte 11.

La idea central es que la portabilidad no se improvisa al final: se decide al principio. Cuanto antes sepas a qué pantallas, controles y tiendas apuntas, más baratas serán tus decisiones de arquitectura y menos código tendrás que rehacer. Esta clase no exporta nada todavía; te da el criterio para que las seis clases siguientes tengan sentido.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Clasificar las plataformas objetivo (PC, móvil, consola, web) por sus restricciones clave.
2. Anticipar cómo el input, la potencia y la tienda condicionan el diseño desde el inicio.
3. Distinguir plataformas "abiertas" de plataformas con certificación obligatoria.
4. Estimar el esfuerzo relativo de portar un mismo juego a cada destino.
5. Elaborar una tabla de decisión de plataformas para un proyecto concreto.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | PC (Windows/Linux/macOS) | Plataforma de desarrollo y baseline de potencia. |
| 2 | Móvil (Android/iOS) | Táctil, batería y tiendas con revisión. |
| 3 | Consola (Switch/PS/Xbox) | Kits de desarrollo, NDA y certificación estricta. |
| 4 | Web (HTML5/WASM) | Sin instalación, pero límites de memoria y APIs. |
| 5 | Restricciones de input | Táctil, gamepad, teclado: cambian la UI. |
| 6 | Restricciones de potencia | GPU/CPU/RAM limitan el presupuesto gráfico. |
| 7 | Tiendas y certificación | Reglas de publicación y control de calidad. |
| 8 | Portabilidad temprana | Decidir pronto evita rehacer sistemas. |

## 📖 Definiciones y características

- **Plataforma objetivo**: destino de ejecución del juego (Windows, Android, Web…). Clave: cada una tiene su propia plantilla de exportación en Godot.
- **Certificación**: revisión obligatoria del fabricante (consolas) o la tienda (App Store) antes de publicar. Clave: puede tardar días o semanas y exigir cambios.
- **Kit de desarrollo (devkit)**: hardware/SDK oficial para consolas, bajo NDA. Clave: no se accede sin acuerdo con el fabricante.
- **Presupuesto de rendimiento**: límite de draw calls, memoria y CPU por frame. Clave: es mucho menor en móvil y web que en PC.
- **Modelo de input**: cómo entra el jugador (táctil, mando, ratón). Clave: un juego solo-táctil no se traslada directo a consola.
- **Tienda (store)**: canal de distribución (Google Play, App Store, Steam, itch.io). Clave: define comisión, requisitos y proceso de alta.
- **Portabilidad**: facilidad de mover el juego entre plataformas. Clave: mejora si abstraes input y UI desde el diseño.
- **Renderer**: backend gráfico de Godot (Forward+, Mobile, Compatibility). Clave: móvil y web piden Mobile o Compatibility.
- **NDA (acuerdo de confidencialidad)**: contrato que exigen los fabricantes de consola para acceder a sus SDK. Clave: sin firmarlo no obtienes devkit ni documentación.
- **Baseline**: plataforma de referencia sobre la que desarrollas (normalmente PC). Clave: mides el esfuerzo de los demás ports respecto a ella.

## 🧰 Herramientas y preparación

No necesitas exportar nada todavía: esta clase es de análisis y decisión. Ten a mano tu proyecto del curso y una hoja de cálculo o un documento donde armar la tabla comparativa. Conviene revisar la matriz de features de Godot para ver qué soporta cada plataforma y qué renderer aplica.

Consulta la guía de exportación en <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html> y la lista de plataformas soportadas en <https://docs.godotengine.org/en/stable/about/list_of_features.html>. Para requisitos de tiendas, ten abiertas las páginas oficiales de Google Play y App Store como referencia.

No hace falta que decidas hoy todas las plataformas de forma definitiva, pero sí que dejes por escrito tus candidatas y sus riesgos. Ese documento vivo se irá refinando en las clases siguientes: la 201 y 202 aterrizan el export a Android e iOS, la 203 y 205 resuelven input y pantallas, y la 204 y 206 cubren rendimiento y monetización. La tabla de esta clase es el índice que conecta todas ellas.

## 🧪 Laboratorio guiado

Vamos a producir una **tabla de decisión de plataformas** para tu juego del curso.

1. Define el juego objetivo en una frase (género, cámara, controles). Ejemplo: "plataformas 2D con salto y ataque, control por gamepad/teclado en PC".

2. Crea una tabla con una fila por plataforma candidata y estas columnas: **Input principal**, **Potencia disponible**, **Renderer recomendado**, **Tienda**, **¿Certificación?**, **Esfuerzo de port (1-5)**, **Decisión (sí/no/después)**.

3. Rellena PC: input teclado+gamepad, potencia alta, renderer Forward+, tienda Steam/itch.io, sin certificación estricta, esfuerzo 1 (es tu baseline), decisión "sí".

4. Rellena Móvil (Android/iOS): input táctil (necesitas controles en pantalla), potencia media-baja, renderer Mobile, tiendas Google Play/App Store con revisión, certificación media (políticas de tienda), esfuerzo 3-4 por la UI táctil, decisión según tu público.

5. Rellena Web: input teclado/ratón/táctil, potencia limitada (memoria WASM), renderer Compatibility, tienda itch.io/web propia, sin certificación, esfuerzo 2-3, decisión útil para demos.

6. Rellena Consola: input gamepad, potencia media-alta, renderer según SDK, tienda del fabricante, **certificación estricta con devkit y NDA**, esfuerzo 5, decisión normalmente "después". Anota que Godot no incluye export oficial de consolas: se hace vía terceros con contrato.

7. Marca en rojo cada celda que obligue a rehacer algo (p. ej. "Móvil: falta UI táctil"). Esas celdas son tu backlog de portabilidad y las abordaremos en las clases 201-207.

8. Escribe abajo 3 decisiones tempranas derivadas de la tabla. Ejemplo: "abstraer input en acciones, no en teclas concretas", "reservar presupuesto para renderer Mobile", "diseñar UI que quepa en 16:9 y en pantallas altas".

9. Añade una fila de **"riesgo principal"** por plataforma: la razón más probable por la que ese port fracase (p. ej. "Web: se queda sin memoria", "iOS: no tengo Mac", "Móvil: controles táctiles incómodos"). Tener el riesgo escrito te obliga a mitigarlo pronto en vez de descubrirlo al final.

Con esta tabla sabes a qué plataformas apuntas y qué trabajo implica cada una antes de escribir más código.

### Cómo leer tu tabla

Una tabla de decisión no es un adorno: es un contrato contigo mismo. Cada "sí" te compromete a un presupuesto de rendimiento, un modelo de input y un proceso de tienda concretos; cada "después" te recuerda no cerrar puertas de diseño que luego costará reabrir. Si dos plataformas comparten input y renderer (por ejemplo PC y Web con teclado/ratón), portar entre ellas es barato; si difieren en ambos (PC y Móvil), el port es un mini-proyecto. Usa esa distancia para ordenar tu hoja de ruta: primero los destinos cercanos a tu baseline, después los lejanos.

## ✍️ Ejercicios

1. Añade una columna "Comisión de tienda" y busca el porcentaje real de Google Play, App Store y Steam.
2. Marca qué plataformas de tu tabla exigen soporte táctil obligatorio.
3. Reordena las filas por esfuerzo de port ascendente y justifica el orden.
4. Identifica un sistema de tu juego que rompería en móvil y propón una alternativa.
5. Investiga qué renderer usarías para una demo web y por qué no Forward+.
6. Escribe qué decisión de diseño tomarías hoy si supieras que en un año irás a consola.
7. Ordena tus plataformas por "distancia al baseline" (cuánto input+renderer difieren de PC) y compárala con el orden por esfuerzo.

## 📝 Reto verificable

Entrega una tabla comparativa completa de al menos **cuatro plataformas** (PC, Android, iOS o Web, y una consola) para tu juego, con las siete columnas del laboratorio rellenas, un puntaje de esfuerzo justificado por plataforma y una lista final de **tres decisiones tempranas** de portabilidad derivadas de la tabla.

**Criterio de aceptación**: la tabla incluye input, potencia, renderer, tienda, certificación, esfuerzo (1-5) y decisión por cada plataforma; cada celda de "esfuerzo" tiene una razón escrita; y las tres decisiones tempranas se conectan explícitamente con celdas concretas de la tabla.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| El juego "no cabe" en móvil al final del proyecto | No se decidió la plataforma temprano. Define destinos antes de diseñar UI e input. |
| Asumir que consola es "exportar y listo" | Godot no trae export oficial de consolas; requiere terceros, devkit y certificación. Plantéalo desde el inicio. |
| UI ilegible al portar a otra pantalla | Se diseñó para una sola resolución. Usa anclas y contenedores desde ya (ver clase 205). |
| Rendimiento inaceptable en móvil/web | Se usó Forward+ sin presupuesto. Prevé Mobile/Compatibility en la decisión. |
| Sorpresa con comisiones o requisitos de tienda | No se revisaron las políticas antes. Inclúyelas en la tabla de decisión. |
| Se prometió consola en el pitch sin plan real | Se ignoró el devkit/NDA/certificación. Marca consola como "después" hasta tener el acuerdo. |
| El mismo control no funciona en dos plataformas | Se acopló el input a teclas concretas. Abstrae en acciones del Input Map desde el diseño. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo exportar a Nintendo Switch o PlayStation desde Godot directamente?** No de forma oficial: necesitas un acuerdo con el fabricante (devkit, NDA) y normalmente un porteador externo. Por eso el esfuerzo de consola es alto y se planifica aparte.

**❓ ¿Web cuenta como plataforma con restricciones?** Sí: hay límites de memoria del entorno WASM, algunas APIs no están disponibles y conviene el renderer Compatibility. Es ideal para demos, no siempre para el juego completo.

**❓ ¿Debo elegir todas mis plataformas al principio?** Al menos las principales, sí. Muchas decisiones de input, UI y renderer son difíciles de revertir; declararlas temprano ahorra rehacer trabajo.

**❓ ¿La certificación aplica en Android e iOS?** Hay revisión de tienda (políticas, contenido, permisos), más estricta en App Store. No es tan formal como la certificación de consola, pero puede rechazar tu build.

**❓ ¿Diseño para la plataforma más limitada o para la más potente?** Como regla, diseña el *gameplay* pensando en tu plataforma más restrictiva (input y potencia) y luego enriquece en las más capaces. Es mucho más fácil añadir efectos en PC que recortar un juego que solo cabe en un tope de gama.

**❓ ¿Qué gano documentando el "riesgo principal" de cada port?** Convierte un miedo difuso ("no sé si funcionará en móvil") en una tarea accionable ("validar controles táctiles en la semana 2"). Los riesgos escritos se mitigan; los no escritos explotan al final.

## 🔗 Referencias

- Godot Docs — Exporting projects: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html>
- Godot Docs — List of features (plataformas y renderers): <https://docs.godotengine.org/en/stable/about/list_of_features.html>
- Google Play — Políticas para desarrolladores: <https://play.google.com/about/developer-content-policy/>
- Apple — App Store Review Guidelines: <https://developer.apple.com/app-store/review/guidelines/>

## ➡️ Siguiente clase

[Clase 201 - Exportar a Android: setup y firma](../201-exportar-a-android-setup-y-firma/README.md)
