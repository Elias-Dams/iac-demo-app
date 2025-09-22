# IaC workshop

## Opstelling

Terraform maakt gebruik van plugins, genaamd providers.
Deze providers definieren de resources die gebruikt kunnen worden en voorzien
hoe deze resources gemanaged worden.

In deze repo worden de volgende providers gerbruikt:

- [de officiele Azure provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Archive plugin](https://registry.terraform.io/providers/hashicorp/archive/latest)
- [Random plugin](https://registry.terraform.io/providers/hashicorp/random/latest)
Een terraform project heeft meestal de volgende layout:

- main.tf
- provider.tf
- variables.tf
- variables.tfvars
- outputs.tf
- [...].tf

### main.tf

Bij conventie de plaats waar de (main) resources geconfigureerd zijn.

### provider.tf

De plaats waar 1 of meerder providers en back-ends voor
de state file geconfigureerd zijn.

### variables.tf

Declaratie van alle input variabelen.

### variables.tfvars

Bestanden die eindigen met ```.tfvars``` bevatten waardes voor input variabelen.

Deze ```.tfvar``` bestanden moeten expliciet meegegeven worden tijdens het uitvoeren.

*Enkel als het bestand eidigt met ```.auto.tfvar``` zal terraform
het automatisch meenement bij het uitvoeren.*

### outputs.tf

Declaratie van alle output waardes. Deze kunnen na of
tijdens het uitvoeren bekeken of gebruikt worden.

### [...].tf

Bovenstaande bestandsnamen zijn enkel conventie.
Terraform zal alle bestanden die eindigen op ```.tfvar```
in een folder meenemen en bundelen.

## Benodigde Azure resources

### Storage account en container

Een Azure Storage Account is een container waarin alle
opslagservices van Azure worden beheerd.
Het fungeert als een basisentiteit die
toegang geeft tot verschillende soorten opslag, zoals:

- Blobs (onbeperkte objectopslag)
- Files (bestandsopslag)
- Queues (wachtrijopslag)
- Tables (NoSQL-opslag)

Binnen een Storage Account bevinden zich Blob Containers.
Een Blob Container is een logische groep om blobs in op te slaan.
Blobs zijn eenheden van ongestructureerde data,
zoals afbeeldingen, video's, documenten of back-ups.

Storage account naming restrictions:

- lowercase
- globally unique
- 3-24 characters

Storage account en storage container config:

- tier = Standard
- replication type = LRS
- container access type = blob

Blobs in een container kunnen van verschillende types zijn.
Gebruik hier (en in de meeste gevallen):

- type = Block

### Function apps

Een function app is een serverless applicatie die reageert
op triggers en dus event-driven werkt.

Een of meerdere function apps zitten altijd in een app service plan.
Dit app service plan bepaalt de resources die de function app ter beschikking heeft.

App service plan en function app config:

- sku_name = Y1
- os_type = Windows [tip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app)
- custom runtime = true
- setting "WEBSITE_RUN_FROM_PACKAGE" = url naar de package
