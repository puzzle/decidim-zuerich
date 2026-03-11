# Decidim Zürich

Decidim installations for the City of Zurich. This repository contains the customizations and configurations for the municipal participation platforms.

## Live Platforms

| Platform | URL | Description |
|----------|-----|-------------|
| **Mitwirken** | [mitwirken.stadt-zuerich.ch](https://mitwirken.stadt-zuerich.ch) | Platform for municipal participation processes |
| **Mein Quartier (until 2025)** | [meinquartier.zuerich](https://meinquartier.zuerich) | Platform for neighborhood organizations |

## Documentation

- **[Wiki](https://github.com/puzzle/decidim-zuerich/wiki)** — Zurich-specific adaptations, processes, and development documentation
- **Graphical changes** — CSS styles and design customizations are maintained in the [Urban Equipe decidim-zurich-css-styles](https://github.com/Urban-Equipe/decidim-zurich-css-styles) repository

## Installation

[OpenShift installation guide](./doc/installation_openshift.md)

## References

This open-source repository is based on [Decidim](https://github.com/decidim/decidim) [v0.27.6](https://github.com/decidim/decidim/releases/tag/v0.27.6).

All significant changes from Decidim (modules and CSS excluded) are documented under the [Enhancement](https://github.com/puzzle/decidim-zuerich/issues?q=is%3Aissue+label%3Aenhancement+is%3Aclosed) label.

## Machine Translation

Machine translation is set up with [Microsoft Translator](https://www.microsoft.com/en-us/translator/) via the [microsoft_translator](https://github.com/ikayzo/microsoft_translator) gem.

### Required environment variables

```bash
TRANSLATOR_ENDPOINT_URL=https://mitwirken-stadt-zuerich.cognitiveservices.azure.com/
TRANSLATOR_SECRET_KEY=*******
```

> **Note:** Machine translation must also be enabled in the tenant settings.

## External / Custom Modules

| Module | Source | Description |
|--------|--------|-------------|
| **decidim-anonymous_codes** | [openpoke/decidim-module-anonymous_codes](https://github.com/openpoke/decidim-module-anonymous_codes) | Anonymous participation via codes for surveys and forms |
| **decidim-anonymous_proposals** | [openpoke/decidim-module-anonymous_proposals](https://github.com/openpoke/decidim-module-anonymous_proposals) | Anonymous proposal creation without user registration |
| **decidim-antivirus** | [puzzle/decidim-module-antivirus](https://github.com/puzzle/decidim-module-antivirus) | Antivirus scanning for file uploads |
| **decidim-decidim_awesome** | [decidim-ice/decidim-module-decidim_awesome](https://github.com/decidim-ice/decidim-module-decidim_awesome) | Extensible enhancements: custom fields, proposals validation, scopes |
| **decidim-decidim_geo** | [git.octree.ch/decidim/decidim-module-geo](https://git.octree.ch/decidim/decidim-module-geo) | Geographic features: maps, geocoding, spatial data (PostGIS) |
| **decidim-guest_meeting_registration** | [OpenSourcePolitics/guest-meeting-registration](https://github.com/OpenSourcePolitics/guest-meeting-registration) | Meeting registration without requiring a user account |
| **decidim-participatory_documents** | [openpoke/decidim-module-participatory-documents](https://github.com/openpoke/decidim-module-participatory-documents) | Collaborative document annotation and commenting |
| **decidim-survey_multiple_answers** | [OpenSourcePolitics/decidim-module-survey_multiple_answers](https://github.com/OpenSourcePolitics/decidim-module-survey_multiple_answers) | Multiple answers per survey question |
| **decidim-term_customizer** | [OpenSourcePolitics/decidim-module-term_customizer](https://github.com/OpenSourcePolitics/decidim-module-term_customizer) | Platform-wide term customization (labels, translations) |

## Technical Documentation

Additional technical documentation and bug reports are located in the [docs/](./docs/) folder.
