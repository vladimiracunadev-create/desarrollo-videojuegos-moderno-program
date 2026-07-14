# Clase 264 — Testing automatizado de juegos (GUT)

> Parte: **15 — Herramientas, editores y automatización (tooling)** · Fuente: *Documentación de GUT (Godot Unit Test) y Godot 4 (Unit testing / GDScript)*
> ⏱️ Duración estimada: **80 min** · Nivel: **Avanzado**

---

## 🎯 Objetivo

Un juego tiene mucho arte y física difíciles de testear, pero también tiene **lógica pura** —daño, inventario, economía— que se puede verificar de forma automática y barata. En esta clase adoptamos **GUT (Godot Unit Test)**, el framework de pruebas unitarias más usado en Godot, para blindar esa lógica: escribimos tests que fallan en rojo cuando alguien rompe una regla de negocio, mucho antes de que el bug llegue al jugador.

Aprenderás a instalar GUT como addon, a escribir clases de test que `extends GutTest` con métodos `test_*()` y aserciones (`assert_eq`, `assert_true`, `assert_null`), y a **ejecutarlos por línea de comandos** con `-s addons/gut/gut_cmdln.gd`. Cerraremos el círculo de la parte: integraremos esta ejecución en el workflow de CI para que cada push corra la batería de tests automáticamente.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Justificar qué lógica de un juego conviene testear y cuál no aporta valor testear.
2. Instalar y activar el addon GUT en un proyecto de Godot 4.
3. Escribir una clase de test con `extends GutTest`, métodos `test_*()` y aserciones adecuadas.
4. Ejecutar la batería de tests por CLI con `gut_cmdln.gd` y leer el resumen de resultados.
5. Integrar la ejecución de tests como un paso de GitHub Actions que falle el build si algún test falla.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Por qué testear juegos | Protege reglas de negocio (daño, economía) ante cambios. |
| 2 | Qué testear y qué no | La lógica pura sí; el render y el feel, no con unit tests. |
| 3 | GUT como addon | Aporta el runner, las aserciones y la integración con el editor. |
| 4 | Estructura de un test | `extends GutTest`, métodos `test_*`, `before_each`. |
| 5 | Aserciones | `assert_eq`, `assert_true`, `assert_null` expresan lo esperado. |
| 6 | Arrange-Act-Assert | Patrón que hace legible cada test. |
| 7 | Ejecución por CLI | Permite correr sin editor y en CI. |
| 8 | Integración en CI | Un test rojo debe romper el build. |

## 📖 Definiciones y características

- **Test unitario**: prueba automática de una unidad de lógica aislada. Clave: rápido, determinista y sin dependencias del render.
- **GUT (Godot Unit Test)**: framework de pruebas para Godot con runner de editor y de CLI. Clave: los tests son escenas/scripts GDScript.
- **`extends GutTest`**: clase base de la que hereda todo archivo de test. Clave: aporta las aserciones y el ciclo de vida.
- **Método `test_*()`**: función cuyo nombre empieza por `test_`; GUT la ejecuta como caso. Clave: cada uno prueba una cosa.
- **Aserción**: comprobación que pasa o falla (`assert_eq`, `assert_true`, `assert_null`). Clave: define el criterio de éxito.
- **`before_each` / `after_each`**: ganchos que preparan y limpian el estado antes/después de cada test. Clave: aíslan casos entre sí.
- **`gut_cmdln.gd`**: script que ejecuta GUT sin abrir el editor. Clave: se invoca con `godot -s`.
- **Arrange-Act-Assert**: estructura de un test en tres fases: preparar, actuar, comprobar. Clave: mejora la legibilidad y el diagnóstico.

## 🧰 Herramientas y preparación

Necesitas **Godot 4.x** y el addon **GUT** compatible con Godot 4, disponible en el AssetLib del editor o en su repositorio de GitHub. Se instala copiando `addons/gut/` al proyecto y activándolo en `Project → Project Settings → Plugins`. Los tests viven por convención en `res://test/` (o `res://tests/`), cada archivo un conjunto de casos.

Escribiremos una lógica sencilla y comprobable —un sistema de salud e inventario— en `res://src/` y sus tests en `res://test/`. La documentación de GUT está en <https://gut.readthedocs.io/> y su repositorio en <https://github.com/bitwes/Gut>. Conviene añadir un `.gutconfig.json` en la raíz para fijar directorios y opciones de ejecución.

## 🧪 Laboratorio guiado

Vamos a testear la lógica de **salud** e **inventario** y a correr los tests por CLI.

1. Escribe la lógica a probar. Crea `res://src/salud.gd`, una clase pura sin nodos visuales:

```gdscript
class_name Salud
extends RefCounted

var maxima: int
var actual: int

func _init(maxima_inicial: int) -> void:
    maxima = max(1, maxima_inicial)
    actual = maxima

func recibir_dano(cantidad: int) -> void:
    actual = clampi(actual - max(0, cantidad), 0, maxima)

func curar(cantidad: int) -> void:
    actual = clampi(actual + max(0, cantidad), 0, maxima)

func esta_viva() -> bool:
    return actual > 0
```

2. Escribe el test correspondiente en `res://test/test_salud.gd`. Cada método prueba una regla concreta:

```gdscript
extends GutTest

var salud: Salud

func before_each() -> void:
    salud = Salud.new(100)          # Arrange comun a todos los casos

func test_empieza_a_vida_maxima() -> void:
    assert_eq(salud.actual, 100, "Debe iniciar con la vida maxima")

func test_el_dano_resta_vida() -> void:
    salud.recibir_dano(30)
    assert_eq(salud.actual, 70)

func test_la_vida_no_baja_de_cero() -> void:
    salud.recibir_dano(9999)
    assert_eq(salud.actual, 0)
    assert_false(salud.esta_viva(), "Con 0 de vida no debe seguir viva")

func test_curar_no_supera_el_maximo() -> void:
    salud.recibir_dano(50)
    salud.curar(9999)
    assert_eq(salud.actual, 100)
```

3. Añade una segunda lógica y su test para practicar más aserciones. Crea `res://test/test_inventario.gd` (asumiendo un `Inventario` con `agregar`, `buscar` y `total`):

```gdscript
extends GutTest

var inv: Inventario

func before_each() -> void:
    inv = Inventario.new()

func test_inventario_vacio_no_encuentra_nada() -> void:
    assert_null(inv.buscar("pocion"), "Sin items, buscar devuelve null")

func test_agregar_apila_cantidades() -> void:
    inv.agregar("pocion", 2)
    inv.agregar("pocion", 3)
    assert_eq(inv.total("pocion"), 5, "Deben apilarse en la misma ranura")

func test_agregar_item_distinto_ocupa_ranura_nueva() -> void:
    inv.agregar("espada", 1)
    inv.agregar("escudo", 1)
    assert_true(inv.total("espada") == 1 and inv.total("escudo") == 1)
```

4. Ejecuta toda la batería **por línea de comandos**, sin abrir el editor. El flag `-gexit` hace que Godot cierre al terminar y devuelva el código de salida:

```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test -gexit
# ...
# ---- Totals ----
# Scripts   2
# Tests     7
# Passing   7   Failing 0
# Codigo de salida: 0
```

5. Integra en CI. En el workflow de la clase 262, añade un paso de tests **antes** del export, de modo que un test rojo detenga el build:

```yaml
      - name: Correr tests GUT
        run: |
          ./godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test -gexit
```

La lección observable: rompe una regla a propósito (haz que `recibir_dano` sume en vez de restar) y vuelve a correr; el test pasa a rojo, el código de salida deja de ser `0` y —en CI— el build entero se marca en rojo antes de exportar nada. La red de seguridad funciona.

## ✍️ Ejercicios

1. Añade a `Salud` un método `porcentaje()` y un test que verifique `assert_almost_eq` con tolerancia.
2. Escribe un test que use `assert_signal_emitted` para comprobar que `Salud` emite una señal `murio` al llegar a 0.
3. Crea una lógica de economía (monedas con `gastar` que no permita saldo negativo) y sus tests.
4. Usa `before_all`/`after_all` para preparar un recurso costoso una sola vez por script.
5. Añade un `.gutconfig.json` que fije `dirs`, `include_subdirs` y ejecuta con `-gconfig`.
6. Provoca un test que falle y aprende a leer el mensaje de GUT para localizar la línea del fallo.

## 📝 Reto verificable

Escribe una lógica de juego pura (salud, inventario o economía) con al menos dos clases y una batería GUT de un mínimo de 8 tests que cubra casos normales y límite (cero, desbordamiento, entrada inválida). Ejecútala por CLI e intégrala como paso de CI que rompa el build ante un fallo.

**Criterio de aceptación**: `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test -gexit` reporta todos los tests en verde y devuelve código de salida `0`; al introducir un bug deliberado en la lógica, al menos un test falla y el código de salida deja de ser `0`, lo que en el workflow de CI marca la ejecución en rojo.

## ⚠️ Errores comunes

| Síntoma | Causa y arreglo |
|---------|-----------------|
| GUT no encuentra los tests | El nombre del archivo o método no empieza por `test_`, o el `-gdir` apunta mal. Revisa convención y ruta. |
| El plugin GUT no aparece en el editor | No se activó en `Project Settings → Plugins`. Actívalo tras copiar `addons/gut/`. |
| CI pasa aunque un test falle | Falta `-gexit`; sin él Godot no propaga el código de salida. Añádelo al comando. |
| Tests que dependen del orden | Estado compartido no reiniciado. Usa `before_each` para recrear los objetos en cada caso. |
| `assert_eq` con floats falla por decimales | Comparación exacta de flotantes. Usa `assert_almost_eq` con una tolerancia. |

## ❓ Preguntas frecuentes

**❓ ¿Debo testear el render y las animaciones?** No con unit tests: son costosos y frágiles. Testea la lógica determinista; para lo visual, pruebas manuales o de integración.

**❓ ¿GUT sirve para tests de integración?** Sí, puede instanciar escenas y simular frames con `await`, pero empieza por unit tests de lógica pura, que dan más valor por menos esfuerzo.

**❓ ¿Dónde coloco los tests?** Por convención en `res://test/`, separados de `res://src/`. Así puedes excluir la carpeta de la exportación final.

**❓ ¿Cuántos tests son suficientes?** No busques un número: cubre las reglas de negocio y los casos límite (cero, máximos, entradas inválidas). La cobertura útil vale más que la total.

## 🔗 Referencias

- GUT — documentación oficial: <https://gut.readthedocs.io/>
- GUT — repositorio (bitwes/Gut): <https://github.com/bitwes/Gut>
- Godot Docs — Unit testing con GUT: <https://docs.godotengine.org/en/stable/tutorials/scripting/unit_testing.html>
- Godot Docs — Command line tutorial (`-s`): <https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html>

## ➡️ Siguiente clase

[Clase 265 - Editores de niveles y contenido in-game](../265-editores-de-niveles-y-contenido-in-game/README.md)
