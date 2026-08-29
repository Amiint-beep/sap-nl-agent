import os
from pathlib import Path

import httpx
from dotenv import load_dotenv
from mcp.server.fastmcp import FastMCP

load_dotenv(Path(__file__).parent / ".env")

BASE_URL = os.getenv("SAP_BTP_BASE_URL")
COOKIE = os.getenv("SAP_BTP_COOKIE")

if not BASE_URL or not COOKIE:
    raise RuntimeError("SAP_BTP_BASE_URL ou SAP_BTP_COOKIE absent du .env")

mcp = FastMCP("sap-article-agent")


@mcp.tool()
def get_materials(storage_location: str | None = None,
                  plant: str | None = None,
                  limit: int = 50) -> list[dict]:
    """Renvoie les articles en stock, filtres par magasin et/ou division.

    Args:
        storage_location: magasin (ex. 'MP01', 'EM01', 'PF01', 'DIV1').
        plant: division / societe (ex. '1000', '2000').
        limit: nombre maximum d'articles renvoyes.
    """
    filters = []
    if storage_location:
        filters.append(f"StorageLocation eq '{storage_location}'")
    if plant:
        filters.append(f"Plant eq '{plant}'")

    params = {
        "$top": str(limit),
        "$select": "MaterialId,MaterialDescription,BaseUnit,StockQuantity,StorageLocation,Plant",
    }
    if filters:
        params["$filter"] = " and ".join(filters)

    headers = {"Cookie": COOKIE, "Accept": "application/json"}

    try:
        response = httpx.get(f"{BASE_URL}/Article", params=params, headers=headers, timeout=30)
        response.raise_for_status()
        return response.json()["value"]
    except Exception as e:
        return [{"erreur": str(e)}]


if __name__ == "__main__":
    mcp.run()