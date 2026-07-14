# Clase 209 — Desarrollo para consolas: panorama y devkits

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Programas oficiales de desarrollo de Nintendo, Sony y Microsoft; documentación de W4 Games*
> ⏱️ Duración estimada: **70 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Comprender cómo funciona realmente el desarrollo para consolas (Nintendo Switch, PlayStation, Xbox) y por qué es un mundo distinto al de PC y móvil: es un entorno **cerrado, bajo NDA (acuerdo de confidencialidad)**, con **programas de desarrollador** por aprobación, **devkits** (hardware especial) y costes asociados. Aquí no puedes simplemente descargar un SDK y exportar.

Un punto central para Godot 4: **el motor no exporta oficialmente a consolas**. La ruta habitual es recurrir a **porteadores** especializados —empresas como **W4 Games** o estudios third-party como **Lone Wolf Technology**— que disponen de los SDK bajo NDA y adaptan tu juego a cada plataforma. Al terminar sabrás mapear la ruta completa para llevar un juego de Godot a consola: requisitos, actores implicados, costes y tiempos aproximados.

Esta clase es **analítica y de planificación**: no escribimos código, sino que construimos el mapa de decisiones que todo estudio debe tener claro antes de comprometer meses de trabajo a un lanzamiento en consola. Entender bien este panorama evita sorpresas caras y expectativas irreales sobre plazos.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Explicar por qué las consolas son plataformas cerradas y qué implica el NDA.
2. Identificar los programas de desarrollador de Nintendo, Sony y Microsoft y cómo se accede.
3. Describir qué es un devkit y en qué se diferencia de una consola comercial.
4. Justificar por qué Godot necesita un porteador para llegar a consola y qué hace W4 Games.
5. Mapear la ruta de porteo de un juego propio: requisitos, actor, costes y tiempos.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Plataforma cerrada vs abierta | Explica todas las fricciones del proceso. |
| 2 | Programas de desarrollador | Es la puerta de entrada, por aprobación. |
| 3 | NDA y confidencialidad | Marca qué puedes contar y qué no. |
| 4 | Devkits | Sin ellos no pruebas ni certificas. |
| 5 | Godot sin export oficial a consola | Define la necesidad de un porteador. |
| 6 | Porteadores (W4, third parties) | Son quienes tienen el SDK y hacen el port. |
| 7 | Costes y requisitos | Determinan la viabilidad del proyecto. |
| 8 | Tiempos y planificación | El porteo se planifica con meses de margen. |

## 📖 Definiciones y características

- **Plataforma cerrada**: ecosistema controlado por el fabricante, con acceso restringido a herramientas. Clave: no hay SDK público descargable.
- **Programa de desarrollador**: registro oficial (Nintendo Developer Portal, PlayStation Partners, ID@Xbox) que concede acceso por aprobación. Clave: suele exigir empresa registrada y un proyecto viable.
- **NDA (Non-Disclosure Agreement)**: acuerdo legal que prohíbe divulgar detalles técnicos del hardware/SDK. Clave: limita qué información es pública.
- **Devkit**: hardware de desarrollo, distinto de la consola de tienda, que permite depurar y ejecutar builds sin firmar. Clave: imprescindible para probar y certificar.
- **Export oficial a consola**: Godot **no** lo provee. Clave: la vía es un porteador con acceso al SDK bajo NDA.
- **Porteador (porting house)**: empresa especializada que adapta el juego al SDK de la consola. Clave: **W4 Games** ofrece porteo de Godot; hay third parties como **Lone Wolf Technology**.
- **W4 Games**: empresa fundada por contribuidores de Godot que da soporte comercial y porteo a consolas. Clave: referencia principal para llevar Godot a consola.
- **Certificación**: proceso de aprobación técnica del fabricante (se ve en la clase 210). Clave: sin pasarla, el juego no se publica.
- **Third party (porting house)**: estudio externo especializado en porteo, como **Lone Wolf Technology**. Clave: alternativa o complemento a W4 para llegar a consola.
- **Lote de aprobación**: fase en que el fabricante revisa el build antes de dejarlo en la tienda. Clave: puede requerir varias iteraciones.

## 🧰 Herramientas y preparación

En esta clase no se programa: es analítica y de planificación. Ten a mano información pública de los tres programas: **Nintendo Developer Portal** <https://developer.nintendo.com>, **PlayStation Partners** <https://partners.playstation.net> e **ID@Xbox** <https://www.xbox.com/developers/id>. Para la vía Godot, consulta **W4 Games** <https://www.w4games.com>.

Prepara una hoja de cálculo o documento donde registrar, por consola objetivo: requisitos de acceso, porteador candidato, coste estimado, hardware necesario y tiempos. No firmes ni aceptes ningún NDA en clase; el objetivo es entender el mapa, no contratar.

Ten presente que la información pública es limitada por diseño: los fabricantes reservan los detalles finos para desarrolladores aprobados. Trabaja con lo que sí es público (requisitos de acceso, existencia de porteadores, orden de magnitud de costes) y marca claramente qué datos habría que confirmar con el fabricante o el porteador una vez dentro del programa.

## 🧪 Laboratorio guiado

Vamos a mapear la ruta para llevar un juego de Godot 4 a una consola concreta. Es un ejercicio de investigación estructurada.

1. **Elige una consola objetivo** para tu juego (por ejemplo, Nintendo Switch por su afinidad con juegos indie 2D/3D pequeños).

2. **Investiga el programa de desarrollador** correspondiente. Anota: ¿pide empresa registrada? ¿Hay que presentar el juego para aprobación? ¿El registro tiene coste?

3. **Localiza el porteador**. Para Godot, contacta conceptualmente con **W4 Games** o un third party. Anota qué ofrecen: ¿portan ellos o te dan acceso a un export? ¿Incluyen certificación?

4. **Estima requisitos técnicos** de tu juego que afectan al porteo: uso de shaders avanzados, tamaño de assets, dependencia de plugins que quizá no existan en consola.

5. **Estima costes**: registro del programa (a menudo bajo o gratuito para indies aprobados), coste del porteo (variable según complejidad), posible coste de devkit.

6. **Estima tiempos**: aprobación del programa (semanas), porteo (semanas a meses según estado del juego), certificación (iteraciones de días a semanas).

7. **Contrasta con la realidad del juego**: revisa si tu proyecto usa características que suelen dar problemas en el porteo (efectos de post-proceso pesados, muchos assets sin comprimir, plugins específicos de escritorio) y anótalas como trabajo previo antes de contactar al porteador.

8. Vuelca todo en una tabla de decisión:

```text
Consola objetivo:        Nintendo Switch
Programa:                Nintendo Developer Portal (por aprobación)
Porteador:               W4 Games / third party
Export oficial Godot:    No existe -> vía porteador (SDK bajo NDA)
Devkit necesario:        Sí (lo gestiona normalmente el porteador)
Coste estimado:          Registro + porteo + (posible devkit)
Tiempo estimado:         Aprobación + porteo + certificación
Riesgos técnicos:        Shaders/plugins no soportados, rendimiento
```

Con este mapa tienes una decisión informada sobre si —y cómo— llevar tu juego a esa consola. Repite el ejercicio para cada plataforma candidata y compáralas: rara vez conviene ir a las tres a la vez desde el primer día.

## ✍️ Ejercicios

1. Repite el mapeo para PlayStation y para Xbox y compara los tres programas.
2. Investiga y resume en un párrafo qué es **ID@Xbox** y a qué tipo de estudios va dirigido.
3. Lista tres características técnicas de tu juego que podrían complicar el porteo y por qué.
4. Explica con tus palabras por qué Godot no incluye un export oficial a consolas.
5. Busca un ejemplo público de juego hecho con Godot que haya salido en consola y describe su ruta.
6. Redacta las preguntas que le harías a un porteador antes de contratarlo.
7. Estima, con órdenes de magnitud, cuánto tiempo total pasaría desde "juego terminado en PC" hasta "disponible en la tienda de la consola".

## 📝 Reto verificable

Elabora un **informe de viabilidad de porteo** de un juego propio (o de ejemplo) a una consola concreta, cubriendo: programa de desarrollador y su vía de acceso, porteador candidato y su rol, necesidad de devkit, riesgos técnicos del juego, y una estimación razonada de costes y tiempos por fases.

**Criterio de aceptación**: el informe identifica correctamente que Godot no exporta oficialmente a consola y depende de un porteador, nombra un actor real (p. ej. W4 Games), y presenta una estimación de costes y tiempos coherente con las fases de aprobación, porteo y certificación.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "Descargo el SDK de Switch y exporto" | No existe SDK público ni export oficial de Godot. Se necesita porteador bajo NDA. |
| Planificar el porteo para "la semana que viene" | El proceso lleva semanas o meses; planifica con margen amplio. |
| Publicar detalles técnicos del devkit | Vulnera el NDA. Nunca divulgues información confidencial del SDK. |
| Asumir que el port es automático | El porteador adapta código, rendimiento y APIs; no es un botón. |
| Ignorar la certificación en la estimación | Es obligatoria y puede requerir varias iteraciones; inclúyela. |
| Subestimar el coste total del proyecto | Suma registro, porteo, devkit y horas de soporte, no solo una tarifa. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo exportar a consola directamente desde Godot?** No. Godot no incluye export oficial a consolas. La vía real es un porteador (como W4 Games) que tiene el SDK bajo NDA y adapta tu juego.

**❓ ¿Qué es exactamente un devkit?** Un hardware de desarrollo distinto de la consola de tienda, que permite ejecutar y depurar builds sin firmar y realizar la certificación.

**❓ ¿Cualquiera puede registrarse como desarrollador de consola?** No de forma abierta: los programas funcionan por aprobación y suelen exigir una empresa y un proyecto viable.

**❓ ¿Por qué tanto secretismo (NDA)?** Los fabricantes protegen detalles del hardware y del SDK. El NDA limita qué puedes compartir públicamente sobre el proceso.

## 🔗 Referencias

- W4 Games (porteo de Godot a consolas): <https://www.w4games.com>
- Lone Wolf Technology (porting house third party): <https://www.lonewolftechnology.com>
- Nintendo Developer Portal: <https://developer.nintendo.com>
- ID@Xbox: <https://www.xbox.com/developers/id>
- PlayStation Partners: <https://partners.playstation.net>

## ➡️ Siguiente clase

[Clase 210 - Certificación (TRC/TCR) y requisitos de consola](../210-certificacion-trc-tcr-y-requisitos-de-consola/README.md)
