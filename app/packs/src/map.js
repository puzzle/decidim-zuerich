/**
 * File copied and adapted from
 * https://github.com/decidim/decidim/blob/develop/decidim-core/app/packs/src/decidim/map.js
 *
 * The only change necessary was to use window.Decidim.createMapController instead of importing
 * this function from src/decidim/map/factory.
 * See also this issue: https://github.com/decidim/decidim/issues/9399
 *
 * Since the original file in Decidim does not run at all in our setup, the easy fix is to import
 * this adapted copy here in our own map provider scripts (gis_zh.js and swisstopo.js).
 */

$(() => {
  let $mapElements = $("[data-decidim-map]");

  $mapElements.each((_i, el) => {
    const $map = $(el);
    let mapId = $map.attr("id");
    if (!mapId) {
      mapId = `map-${Math.random().toString(36).substr(2, 9)}`;
      $map.attr("id", mapId);
    }

    const mapConfig = $map.data("decidim-map");
    const ctrl = window.Decidim.createMapController(mapId, mapConfig);
    const map = ctrl.load();

    $map.data("map", map);
    $map.data("map-controller", ctrl);

    $map.trigger("configure.decidim", [map, mapConfig]);

    ctrl.start();

    // Indicates the map is loaded with the map objects initialized and ready
    // to be used.
    $map.trigger("ready.decidim", [map, mapConfig]);
  });
});
