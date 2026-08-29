# SAP S/4HANA Natural Language Agent.

An AI agent that answers questions about SAP article data in plain language —
and an OData API, built in ABAP Cloud, that serves that data.

## Context

The target user is a business user working in SAP daily — a warehouse
clerk, a warehouse assistant, or a buyer — who needs to look up article
(material) data quickly, without navigating complex SAP transactions.

Instead of remembering transaction codes and filling in selection screens,
they could simply ask, in plain language, for the data they need. In a real
deployment, this agent could run behind a Fiori plugin: the user types a
question in a familiar SAP interface, and the agent handles the request in
the background — making SAP data far more accessible.

## Stage 1 — Consuming a standard SAP API
## How it works

I implemented in Python an agent that reads a user's request in natural
language and uses an LLM to decide which function (tool) to call to
fulfill that request. For now, a single tool is implemented: retrieving
material master data from SAP.

Before the agent runs, it starts an MCP (Model Context Protocol) server
that exposes this tool. When the LLM decides to call the tool, the MCP
server executes the corresponding OData request against SAP's public
sandbox — authenticating with the SAP API key — and returns the raw data.

The agent passes that data back to the LLM, which turns the structured
result into a natural-language answer for the user. The LLM used is
Google's Gemini Flash model, accessed through its own API key.

## What I gained from this project

 — I practiced translating a real user need
(quick, user-friendly access to article data) into a working solution,
while thinking about who uses it and how it fits into their daily work.

— I learned to deliver that solution while
fully respecting and protecting the SAP standard core. The agent requires
no custom development inside standard transactions: it lives entirely
outside the core and only consumes released OData APIs. This is the
clean-core, side-by-side extensibility approach.

## Stage 2 — Producing the API the agent consumes
Stage 1 consumed a prepared API; Stage 2 asks the other question; what does it take to build the entire service on the SAP side?
The data no longer comes from the public sandbox. It comes from an OData V4 service I developed in ABAP Cloud on SAP BTP ABAP Environment:

| `ZARTICLE_TABLE` | Database table | Article master data (textile domain) |
| `ZCL_FILL_ARTICLES` | Class | Test dataset (`if_oo_adt_classrun`) |
| `Z_CDS_ARTICLE` | CDS view entity | Exposed model, CamelCase aliases |
| `Z_DEF_ARTICLE` | Service Definition | Declares the `Article` entity set |
| `Z_BINDING_ARTICLE` | Service Binding | Publishes it as OData V4 Web API |

## The BTP trial wall, and how I got past it

Building the service was the easy part. Making it reachable from outside the
system was not — and this is where the shared trial stops you.
On BTP ABAP Environment, exposing a service to an external client goes
through a Communication Scenario, a Communication System and a Communication
Arrangement. Together they produce a public URL and a dedicated technical
user. Those apps belong to the `SAP_CORE_BC_COM` business catalog — which
does not exist on a shared trial.

What worked: authentication to ABAP systems on BTP rests on browser session
cookies, and nothing requires those cookies to come from a browser. Open the
service URL in the browser, read the `Cookie` request header in the developer
tools, and send the same header from Python. One catch — the API host and the
UI host are different domain names (`...abap.` and `...abap-web.`) and don't
share cookies, which produces an endless login loop if you target the wrong
one.
This is not a security bypass: it reuses my session who already has read access.

## What I gained from stage 2

Stage 1 taught me the consumer side of clean-core extensibility. Stage 2 put
me on the producer side: modelling the data, shaping what the API exposes,
and deciding what belongs in the database rather than in the client.


## Roadmap

- A Fiori plugin, so the user asks the question inside the SAP interface
  they already know
- More tools: suppliers, stock movements
- Replace the cookie workaround