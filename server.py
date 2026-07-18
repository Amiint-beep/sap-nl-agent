import os
import httpx
from dotenv import load_dotenv
from mcp.server.fastmcp import FastMCP


load_dotenv()
API_KEY = os.getenv("SAP_API_KEY") #on réucpere la clé d'api pour l'utiliser pour des requetes sap
BASE_URL = "https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap"


#on créer la fastmcp instance avec son nom pour l'identifier correctement.
mcp = FastMCP("SAP-MM-AGENT")
@mcp.tool() #notice d'utilisation 
def get_materials(product_group: str | None = None,
                  product_type: str | None = None,
                  limit: int = 4) -> list[dict]:
    """Renvoie une liste d'articles depuis SAP.

    Args:
        product_group: filtre optionnel sur le groupe d'articles (ex. 'L001').
        product_type: filtre optionnel sur le type d'article (ex. 'HAWA').
        limit: nombre d'articles à renvoyer (défaut 10).
    """
    #construction pour le filtre OData dynamiquement selon les paramètres.
    filters = []
    if product_group:
        filters.append(f"ProductGroup eq '{product_group}'")
    if product_type:
        filters.append(f"ProductType eq '{product_type}'")

    # Les paramètres OData.
    params = {
        "$top": str(limit),
        "$select": "Product,ProductType,ProductGroup,BaseUnit",
        "$format": "json",
    }
    if filters:
        params["$filter"] = " and ".join(filters)

    # L'appel HTTP réel vers SAP. La clé passe dans l'en-tête APIKey.
    url = f"{BASE_URL}/API_PRODUCT_SRV/A_Product"
    headers = {"APIKey": API_KEY, "Accept": "application/json"}

    # try/except : pour renvoyer une erreur au lieu d'un echec
    # on fait passer l'url construit avec base url et headers dans la requete httpx.get pour récuperer les données.
    try:
        response = httpx.get(url, params=params, headers=headers, timeout=30)
        response.raise_for_status()
        
        return response.json()["d"]["results"]
    except httpx.HTTPStatusError as e:
        return [{"erreur": f"SAP a renvoyé le code {e.response.status_code}"}]
    except Exception as e:
        return [{"erreur": str(e)}]

if __name__ == "__main__": 
    mcp.run()