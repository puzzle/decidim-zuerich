
This is PDF.js version 3.0.279 prebuilt for modern browsers to
which we have done some small changes like adapting the paths 
to where we want to be placed in a decidim project. 

We already tried to to add it via Npm, CDN without any success.

The changes are located in web/viewer.js: 
* **pdf.worker.js** path has been changed to /pdfjs/build/pdf.worker.js
* **standardFontDataUrl** has been set to /pdfjs/web/standard_fonts/
* **cMapUrl** has been set to /pdfjs/web/cmaps/ 
* **imageResourcesPath** has been set to /pdfjs/web/images/ 