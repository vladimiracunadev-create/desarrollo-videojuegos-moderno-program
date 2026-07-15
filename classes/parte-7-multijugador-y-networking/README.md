# Parte 7 — Multijugador y networking

> [⬅️ Volver al programa](../../README.md) · [📚 Índice completo](../README.md) · [⏮️ Parte anterior](../parte-6-audio-y-musica-interactiva/README.md)

**18 clases** · rango 138–155 · Del socket al shooter en red: arquitecturas, MultiplayerAPI de Godot, RPCs, replicación de estado, predicción/reconciliación, rollback, servidores dedicados y seguridad

> 🧪 **Laboratorio ejecutable:** esta parte tiene un proyecto Godot real — [`labs/multijugador`](../../labs/multijugador/README.md) — con versión `inicio/` (para completar) y `solucion/` (referencia jugable), verificado en CI levantando un servidor y varios clientes de verdad.

**Fuentes de referencia de esta parte:**

- Joshua Glazer & Sanjay Madhav, *Multiplayer Game Programming* (Addison-Wesley).
- Glenn Fiedler, *Gaffer On Games* — [artículos sobre networking](https://gafferongames.com/).
- Valve — *Source Multiplayer Networking* y charlas de GDC sobre netcode.
- Documentación de [networking de Godot 4](https://docs.godotengine.org/en/stable/tutorials/networking/index.html) y [Nakama](https://heroiclabs.com/docs/).

---

## 🎯 ¿De qué trata esta parte?

El multijugador es uno de los retos más difíciles del desarrollo de juegos: internet añade latencia, pérdida de paquetes y tramposos, y hay que dar la ilusión de un mundo compartido en tiempo real pese a todo ello. Esta parte va de los fundamentos a un juego en red funcional, con Godot 4. Empezamos por la base: **TCP vs UDP**, latencia y jitter, y los **modelos de arquitectura** (P2P, cliente-servidor, servidor autoritativo) con sus ventajas e inconvenientes.

Luego construimos con las herramientas de alto nivel de Godot: **MultiplayerAPI**, **RPCs**, `MultiplayerSpawner` y `MultiplayerSynchronizer`, un **chat/lobby** paso a paso, y la **replicación de estado** para mover jugadores en red. Después llega lo difícil y lo que separa un juego amateur de uno pulido: **predicción del cliente y reconciliación**, **interpolación/extrapolación**, **lag compensation** y **rollback netcode**, servidor **autoritativo** con anti-cheat básico, serialización eficiente, **matchmaking** y NAT traversal, **servidores dedicados** headless, backends (Nakama, Steam) y seguridad. Cerramos con un **capstone**: un juego en red mínimo cliente-servidor.

## 🧩 Problemas que resuelve

- No saber elegir arquitectura (¿P2P o servidor autoritativo?) y pagarlo caro después.
- Movimiento en red "a saltos" por no interpolar ni predecir.
- Input que se siente lento porque todo espera al servidor (falta de predicción del cliente).
- Juegos fáciles de trampear por confiar en el cliente.
- No poder desplegar un servidor dedicado ni gestionar salas/matchmaking.
- Consumir demasiado ancho de banda por serializar mal el estado.

## 🎓 Resultados de aprendizaje

Al terminar la parte, el alumno podrá:

- Explicar TCP/UDP, latencia y los modelos de arquitectura de red de juegos.
- Usar la MultiplayerAPI de Godot: RPCs, spawner y synchronizer.
- Replicar estado y mover jugadores en red de forma fluida.
- Implementar predicción del cliente, reconciliación e interpolación de entidades.
- Aplicar lag compensation y entender el rollback netcode.
- Montar un servidor autoritativo con validación anti-cheat básica.
- Desplegar servidores dedicados y usar backends de matchmaking (Nakama/Steam).

## 🧱 Prerrequisitos

- Partes 0–3 (redes básicas de la Parte 0, determinismo y física fija de la Parte 3, escenas y movimiento).
- Soltura con señales, instanciado y máquinas de estado (Partes 1 y 5).
- Godot 4.x; para servidores dedicados, nociones básicas de terminal y despliegue.

## 📚 Las 18 clases

| # | Clase |
|---|---|
| 138 | [Fundamentos de redes para juegos: TCP, UDP y latencia](138-fundamentos-de-redes-para-juegos-tcp-udp-y-latencia/README.md) |
| 139 | [Modelos de arquitectura: P2P, cliente-servidor y autoritativo](139-modelos-de-arquitectura-p2p-cliente-servidor-autoritativo/README.md) |
| 140 | [El multijugador de alto nivel de Godot (MultiplayerAPI)](140-el-multijugador-de-alto-nivel-de-godot-multiplayerapi/README.md) |
| 141 | [RPCs: llamadas remotas y sincronización](141-rpcs-llamadas-remotas-y-sincronizacion/README.md) |
| 142 | [MultiplayerSpawner y MultiplayerSynchronizer](142-multiplayerspawner-y-multiplayersynchronizer/README.md) |
| 143 | [Un chat y lobby en red paso a paso](143-un-chat-y-lobby-en-red-paso-a-paso/README.md) |
| 144 | [Mover jugadores en red: replicación de estado](144-mover-jugadores-en-red-replicacion-de-estado/README.md) |
| 145 | [Predicción del cliente y reconciliación](145-prediccion-del-cliente-y-reconciliacion/README.md) |
| 146 | [Interpolación y extrapolación de entidades](146-interpolacion-y-extrapolacion-de-entidades/README.md) |
| 147 | [Lag compensation y rollback netcode](147-lag-compensation-y-rollback-netcode/README.md) |
| 148 | [Servidor autoritativo y anti-cheat básico](148-servidor-autoritativo-y-anti-cheat-basico/README.md) |
| 149 | [Serialización eficiente y ancho de banda](149-serializacion-eficiente-y-ancho-de-banda/README.md) |
| 150 | [Matchmaking, salas y relay (NAT traversal)](150-matchmaking-salas-y-relay-nat-traversal/README.md) |
| 151 | [Servidores dedicados: headless y despliegue](151-servidores-dedicados-headless-y-despliegue/README.md) |
| 152 | [Backends: Nakama, Steam y servicios gestionados](152-backends-nakama-steam-y-servicios-gestionados/README.md) |
| 153 | [Testing de red: simular latencia y pérdida](153-testing-de-red-simular-latencia-y-perdida/README.md) |
| 154 | [Seguridad en multijugador: validación y exploits](154-seguridad-en-multijugador-validacion-y-exploits/README.md) |
| 155 | [Capstone Parte 7: un juego en red mínimo cliente-servidor](155-capstone-parte-7-un-juego-en-red-minimo-cliente-servidor/README.md) |

---

> Has recorrido de los fundamentos al multijugador. Las siguientes partes del [roadmap](../../ROADMAP.md) (game design, arte, plataformas, web, VR/AR, optimización, tooling y publicación) se construyen con este mismo formato.
