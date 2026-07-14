# Clase 202 — Exportar a iOS: setup y provisioning

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Exporting for iOS) · developer.apple.com*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

iOS es la plataforma móvil con más requisitos externos: no basta con Godot, necesitas un **Mac con Xcode**, una cuenta de **Apple Developer**, y toda la maquinaria de **certificados y provisioning profiles** que Apple usa para autorizar qué apps corren en qué dispositivos. Godot 4 no produce un ejecutable listo: exporta un **proyecto de Xcode** que tú compilas y firmas.

En esta clase mapeamos ese flujo completo: instalar plantillas, configurar el preset de iOS, generar el proyecto Xcode, y firmarlo con tu identidad de desarrollador para instalarlo en un iPhone real. Como el paso final exige hardware Apple, describimos con precisión cada acción en Xcode aunque no dispongas de Mac ahora, para que sepas exactamente qué hacer cuando lo tengas.

Comparado con Android, iOS tiene menos pasos dentro de Godot pero más burocracia de Apple alrededor: casi todos los problemas de exportación a iOS no son de Godot, sino de firma (certificado, identificador o perfil mal alineados). Por eso esta clase dedica tanto espacio a entender esas piezas: si las dominas, el resto del flujo es mecánico.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Enumerar los requisitos de exportación a iOS (macOS, Xcode, cuenta Developer).
2. Explicar el rol de certificados, App ID y provisioning profiles.
3. Configurar el preset de iOS en Godot 4 y generar el proyecto Xcode.
4. Abrir, firmar y compilar el proyecto en Xcode.
5. Instalar y probar la app en un dispositivo iOS físico.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Requisitos (macOS + Xcode) | Sin ellos no se compila ni firma iOS. |
| 2 | Cuenta Apple Developer | Habilita firma y publicación. |
| 3 | Certificado de firma | Identidad criptográfica del desarrollador. |
| 4 | App ID / Bundle Identifier | Identifica de forma única tu app. |
| 5 | Provisioning profile | Autoriza qué app corre en qué dispositivos. |
| 6 | Proyecto Xcode exportado | Godot entrega un proyecto, no un binario. |
| 7 | Firma en Xcode | Enlaza certificado, App ID y perfil. |
| 8 | Prueba en dispositivo | Validar en hardware real. |

## 📖 Definiciones y características

- **Xcode**: IDE de Apple que compila y firma apps iOS. Clave: es obligatorio y solo corre en macOS.
- **Apple Developer Program**: membresía (de pago para distribución) que habilita firma y publicación. Clave: sin ella solo puedes hacer pruebas limitadas.
- **Certificado de desarrollo**: par de claves que identifica al desarrollador. Clave: firma los builds para que iOS confíe en ellos.
- **Bundle Identifier / App ID**: identificador único (`com.tuestudio.mijuego`). Clave: debe coincidir en Godot, App ID y perfil.
- **Provisioning profile**: archivo que une App ID, certificado y dispositivos autorizados. Clave: sin un perfil válido, el iPhone rechaza la app.
- **Team ID**: identificador de tu equipo Apple Developer. Clave: Godot y Xcode lo usan para la firma.
- **Signing (automático/manual)**: Xcode puede gestionar certificados y perfiles por ti (automatic) o usarlos que le indiques (manual). Clave: "Automatically manage signing" simplifica el arranque.
- **Proyecto Xcode exportado**: carpeta `.xcodeproj` que Godot genera desde el preset. Clave: es lo que abres y compilas en Xcode.
- **`.ipa`**: paquete final instalable/distribuible de iOS. Clave: lo produce Xcode al archivar y firmar, no Godot directamente.
- **TestFlight**: servicio de Apple para distribuir betas a testers. Clave: pertenece a la fase de publicación, tras archivar en Xcode.

## 🧰 Herramientas y preparación

Necesitas un **Mac** con **Xcode** instalado (App Store), una **cuenta Apple Developer** (gratuita para pruebas en tu propio dispositivo, de pago para publicar), un **iPhone/iPad** con cable, y las **plantillas de exportación** de Godot instaladas. En el iPhone deberás confiar en tu certificado de desarrollador la primera vez (Ajustes → General → VPN y gestión de dispositivos).

Sigue la guía oficial de Godot para iOS en <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html> y la documentación de firma de Apple en <https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases>. Ten tu **Team ID** a mano (aparece en developer.apple.com → Membership).

Si no cuentas con un Mac ahora mismo, no te saltes la clase: los pasos 1 a 4 (instalar plantillas y generar el proyecto Xcode) se hacen en cualquier sistema operativo, y el resto lo puedes preparar como documento para ejecutarlo cuando dispongas de hardware Apple, un Mac prestado o un servicio de CI con macOS. Lo importante es entender el flujo de firma, que es idéntico en todos los casos.

## 🧪 Laboratorio guiado

Configuraremos el export de iOS, generaremos el proyecto Xcode y lo firmaremos. Los pasos 1-4 se hacen en cualquier SO; del 5 en adelante requieren macOS.

1. Instala las **plantillas de exportación** (Editor → Manage Export Templates) que coincidan con tu versión de Godot.

2. En **Project → Export → Add → iOS**, crea el preset. Configura el **Bundle Identifier** (`com.tuestudio.mijuego`) y el **Team ID** de tu cuenta Apple Developer.

3. En el preset, revisa el **Application** (nombre, iconos, launch screen) y, en **Capabilities**, marca solo lo que uses (por ejemplo, sin permisos innecesarios para pasar la revisión más fácil).

4. Pulsa **Export Project…** y elige una carpeta de salida. Godot genera ahí un **proyecto Xcode** (`.xcodeproj`) más los recursos empaquetados. Copia esa carpeta al Mac si exportaste en otro equipo.

5. En el Mac, abre el `.xcodeproj` con **Xcode**. Selecciona el target del juego → pestaña **Signing & Capabilities**.

6. Marca **Automatically manage signing** y elige tu **Team**. Xcode generará o descargará el **certificado** y el **provisioning profile** para tu Bundle Identifier. Si hay conflicto, cambia el Bundle ID a uno único.

7. Conecta el iPhone, selécciónalo como destino en la barra superior de Xcode y pulsa **Run (▶)**. Xcode compila, firma e instala la app en el dispositivo.

8. En el iPhone, la primera vez ve a **Ajustes → General → VPN y gestión de dispositivos**, y **confía** en tu certificado de desarrollador. Vuelve a abrir la app: ya arranca.

9. Para distribución (TestFlight/App Store) usarías **Product → Archive** en Xcode y subirías con el **Organizer**; eso corresponde a la fase de publicación (Parte 16), aquí basta con la prueba en dispositivo.

Con esto tienes el flujo Godot → Xcode → iPhone completo y sabes dónde encaja cada certificado y perfil.

### El flujo de firma en una imagen mental

Piensa la firma iOS como tres piezas que deben encajar: **quién eres** (el certificado, tu identidad criptográfica), **qué app es** (el App ID / Bundle Identifier) y **dónde puede correr** (el provisioning profile, que lista dispositivos y une las dos anteriores). Xcode con "Automatically manage signing" genera y renueva estas piezas por ti a partir de tu Team; solo pasas a firma manual cuando necesitas control fino (por ejemplo, perfiles de distribución específicos o CI). Si algo falla, casi siempre es que una de las tres piezas no coincide con las otras: mismo Bundle Identifier en Godot, en el App ID y en el perfil.

## ✍️ Ejercicios

1. Anota tu **Team ID** y tu **Bundle Identifier** elegidos y explica por qué deben ser únicos.
2. Describe la diferencia entre firma **automática** y **manual** en Xcode y cuándo usarías cada una.
3. Enumera qué necesitas para probar en un dispositivo con cuenta gratuita frente a una de pago.
4. Cambia el icono de la app en el preset de Godot y verifica que aparece en Xcode.
5. Explica por qué Godot exporta un proyecto Xcode y no directamente un `.ipa`.
6. Investiga qué es TestFlight y en qué fase del proyecto lo usarías.
7. Dibuja un diagrama con las tres piezas de la firma (certificado, App ID, provisioning profile) y cómo se unen.
8. Anota qué pasos del laboratorio puedes hacer sin Mac y cuáles no, y por qué.

## 📝 Reto verificable

Genera desde Godot el **proyecto Xcode** de tu juego con un Bundle Identifier y Team ID válidos, ábrelo en Xcode con **Automatically manage signing**, compílalo e instálalo en un iPhone/iPad físico, y confía en el certificado para que la app arranque. Si no dispones de Mac, entrega el proyecto Xcode exportado más un documento que describa, paso a paso y con capturas de la configuración del preset, cómo lo firmarías e instalarías.

**Criterio de aceptación**: existe un `.xcodeproj` generado por Godot con Bundle Identifier y Team ID correctos; en Xcode la pestaña Signing & Capabilities muestra Team y provisioning profile válidos sin errores rojos; y (con hardware Apple) la app corre en el dispositivo tras confiar en el certificado. Sin Mac, el documento describe cada paso de firma de forma verificable.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "No account for team" en Xcode | No añadiste tu Apple ID en Xcode → Settings → Accounts. Inícialo y selecciona el Team. |
| "Failed to create provisioning profile" | Bundle Identifier duplicado o inválido. Usa uno único (dominio inverso propio). |
| "Untrusted Developer" en el iPhone | Falta confiar en el certificado. Ajustes → General → VPN y gestión de dispositivos → Confiar. |
| Xcode no ve el iPhone | Cable/permiso. Desbloquea el teléfono y pulsa "Confiar en este equipo". |
| Exporté en Windows y no puedo compilar | La compilación y firma iOS solo ocurren en macOS con Xcode. Traslada el proyecto a un Mac. |
| La app se cierra al abrir | Capacidad o permiso mal declarado. Revisa Signing & Capabilities y quita capacidades no usadas. |
| El perfil caducó a los pocos días | Cuenta gratuita: sus perfiles son de corta duración. Reinstala o usa la membresía de pago. |

## ❓ Preguntas frecuentes

**❓ ¿Puedo exportar a iOS sin un Mac?** Puedes generar el proyecto Xcode desde Godot en cualquier SO, pero **compilar y firmar** exige macOS con Xcode. No hay atajo oficial que lo evite.

**❓ ¿Necesito pagar la cuenta de Apple Developer para probar?** Para probar en tu propio dispositivo basta una cuenta gratuita (con perfiles de corta duración). Para TestFlight y App Store necesitas la membresía de pago.

**❓ ¿Qué es exactamente un provisioning profile?** Un archivo firmado por Apple que une tu App ID, tu certificado y una lista de dispositivos autorizados. iOS solo ejecuta apps cuyo perfil las autoriza.

**❓ ¿Por qué Godot me da un proyecto Xcode y no un `.ipa` listo?** Porque la firma y el empaquetado final dependen de tu certificado y perfil, que gestiona Xcode. Godot prepara el proyecto y tú lo firmas con tu identidad.

**❓ ¿Cada cuánto caduca el provisioning profile?** Con cuenta gratuita, los perfiles de desarrollo duran pocos días y hay que reinstalar; con la membresía de pago duran alrededor de un año. Xcode los renueva automáticamente si usas firma automática y tu Team es válido.

**❓ ¿Puedo tener la misma app en Android e iOS con el mismo identificador?** Conviene usar el mismo estilo de dominio inverso (`com.tuestudio.mijuego`) en ambas por coherencia, pero cada tienda gestiona su propio registro: el Bundle Identifier de iOS y el package name de Android son independientes entre sí.

## 🔗 Referencias

- Godot Docs — Exporting for iOS: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html>
- Apple Developer — Certificates, Identifiers & Profiles: <https://developer.apple.com/help/account/manage-identifiers/register-an-app-id>
- Apple — Distributing your app for testing and release: <https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases>
- Apple — Signing your apps in Xcode: <https://developer.apple.com/documentation/xcode/signing-your-apps-in-xcode>

## ➡️ Siguiente clase

[Clase 203 - Input táctil y controles móviles](../203-input-tactil-y-controles-moviles/README.md)
