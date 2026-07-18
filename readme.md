## SAP S/4HANA Natural Language Agent.

## Context

The target user is a business user working in SAP daily — a warehouse
clerk, a warehouse assistant, or a buyer — who needs to look up article
(material) data quickly, without navigating complex SAP transactions.

Instead of remembering transaction codes and filling in selection screens,
they could simply ask, in plain language, for the data they need. In a real
deployment, this agent could run behind a Fiori plugin: the user types a
question in a familiar SAP interface, and the agent handles the request in
the background — making SAP data far more accessible.

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