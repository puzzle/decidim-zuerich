/*!
 * Leaflet.TileLayer.Swiss v2.2.1
 * Plugin for displaying Swiss map tiles
 * © Roman Karavia | MIT License
 * leaflet-tilelayer-swiss.karavia.ch
 */
!(function(t, a) {
  "object" == typeof exports && "undefined" != typeof module
    ? (module.exports = a(require("leaflet")))
    : "function" == typeof define && define.amd
    ? define(["leaflet"], a)
    : (((t = "undefined" != typeof globalThis ? globalThis : t || self).L =
        t.L || {}),
      (t.L.TileLayer = t.L.TileLayer || {}),
      (t.L.TileLayer.Swiss = a(t.L)));
})(this, function(t) {
  "use strict";
  function a(t) {
    return t && "object" == typeof t && "default" in t ? t : { default: t };
  }
  var n = a(t),
    e = "EPSG:21781",
    o = "EPSG:2056";
  function r(t) {
    if (!Array.isArray(t)) throw new Error("Expected input to be an array.");
    if (t.length < 2)
      throw new Error(
        "Expected input to be an array with length >= 2, got " + t.length + "."
      );
    if (
      t.some(function(t) {
        return !Number.isFinite(t);
      })
    )
      throw new Error("Expected all coordinates to be finite numbers.");
  }
  function i(t, a, n) {
    return (n / 60 + a) / 60 + t;
  }
  function s(t) {
    return (180 * t) / Math.PI;
  }
  function u(t) {
    return (t * Math.PI) / 180;
  }
  function h(t, a) {
    return {
      apply: function(n) {
        var e = n[0],
          o = n[1],
          r = n.slice(2);
        return [e + t, o + a].concat(r);
      },
      unapply: function(n) {
        var e = n[0],
          o = n[1],
          r = n.slice(2);
        return [e - t, o - a].concat(r);
      }
    };
  }
  void 0 === Number.isFinite &&
    (Number.isFinite = function(t) {
      return "number" == typeof t && isFinite(t);
    });
  var c = h(6e5, 2e5),
    f = c.apply,
    l = c.unapply,
    M = h(26e5, 12e5),
    p = M.apply,
    d = M.unapply;
  function m(t, a) {
    var n = 1 / a,
      e = 2 * n - Math.pow(n, 2);
    return {
      fromCartesian: function(a) {
        var n,
          o,
          r,
          i,
          u,
          h = a[0],
          c = a[1],
          f = a[2],
          l = Math.atan(c / h),
          M = Math.sqrt(Math.pow(h, 2) + Math.pow(c, 2)),
          p = Math.atan(f / ((1 - e) * M));
        do {
          (n = o),
            (r = i),
            (i = t / Math.sqrt(1 - e * Math.pow(Math.sin(p), 2))),
            (u = M / Math.cos(p) - i),
            (p = Math.atan(f / ((1 - (e * i) / (i + u)) * M))),
            (o = Math.abs(i - r));
        } while (isNaN(n) || o < n);
        var d = s(p);
        return [s(l), d, u];
      },
      toCartesian: function(a) {
        var n = a[0],
          o = a[2],
          r = void 0 === o ? 0 : o,
          i = u(a[1]),
          s = u(n),
          h = t / Math.sqrt(1 - e * Math.pow(Math.sin(i), 2));
        return [
          (h + r) * Math.cos(i) * Math.cos(s),
          (h + r) * Math.cos(i) * Math.sin(s),
          (h * (1 - e) + r) * Math.sin(i)
        ];
      }
    };
  }
  var w = m(6377397.155, 299.15281285),
    g = w.fromCartesian,
    v = w.toCartesian,
    y = m(6378137, 298.257223563),
    b = y.fromCartesian,
    j = y.toCartesian,
    x = 1 / 299.15281285,
    L = u(i(46, 57, 8.66)),
    P = u(i(7, 26, 22.5)),
    S = 2 * x - Math.pow(x, 2),
    E = (6377397.155 * Math.sqrt(1 - S)) / (1 - S * Math.pow(Math.sin(L), 2)),
    I = Math.sqrt(1 + (S / (1 - S)) * Math.pow(Math.cos(L), 4)),
    C = Math.asin(Math.sin(L) / I),
    T = Math.sqrt(S),
    _ =
      Math.log(Math.tan(Math.PI / 4 + C / 2)) -
      I * Math.log(Math.tan(Math.PI / 4 + L / 2)) +
      ((I * T) / 2) * Math.log((1 + T * Math.sin(L)) / (1 - T * Math.sin(L)));
  function N(t) {
    var a,
      n = [(a = j(t))[0] - 674.374, a[1] - 15.056, a[2] - 405.346],
      e = g(n),
      o = (function(t) {
        var a = t[0],
          n = u(t[1]),
          e = u(a),
          o =
            I * Math.log(Math.tan(Math.PI / 4 + n / 2)) -
            ((I * T) / 2) *
              Math.log((1 + T * Math.sin(n)) / (1 - T * Math.sin(n))) +
            _,
          r = 2 * (Math.atan(Math.exp(o)) - Math.PI / 4),
          i = I * (e - P),
          s = Math.asin(
            Math.cos(C) * Math.sin(r) - Math.sin(C) * Math.cos(r) * Math.cos(i)
          ),
          h = Math.atan(
            Math.sin(i) /
              (Math.sin(C) * Math.tan(r) + Math.cos(C) * Math.cos(i))
          );
        return [
          E * h,
          (E / 2) * Math.log((1 + Math.sin(s)) / (1 - Math.sin(s)))
        ];
      })(e);
    return t.length > 2 ? [].concat(o, [e[2]]) : o;
  }
  function q(t) {
    var a = (function(t) {
      var a,
        n,
        e,
        o,
        r = t[0],
        i = 2 * (Math.atan(Math.exp(t[1] / E)) - Math.PI / 4),
        u = r / E,
        h = Math.asin(
          Math.cos(C) * Math.sin(i) + Math.sin(C) * Math.cos(i) * Math.cos(u)
        ),
        c = Math.atan(
          Math.sin(u) / (Math.cos(C) * Math.cos(u) - Math.sin(C) * Math.tan(i))
        ),
        f = P + c / I,
        l = h;
      do {
        (a = n),
          (e = o),
          (o =
            (Math.log(Math.tan(Math.PI / 4 + h / 2)) - _) / I +
            T *
              Math.log(Math.tan(Math.PI / 4 + Math.asin(T * Math.sin(l)) / 2))),
          (l = 2 * Math.atan(Math.exp(o)) - Math.PI / 2),
          (n = Math.abs(o - e));
      } while (isNaN(a) || n < a);
      var M = s(l);
      return [s(f), M];
    })(t);
    a.push(t[2]);
    var n,
      e = [(n = v(a))[0] + 674.374, n[1] + 15.056, n[2] + 405.346],
      o = b(e);
    return t.length > 2 ? o : o.slice(0, 2);
  }
  var z = {
    __proto__: null,
    project: function(t) {
      return r(t), f(N(t));
    },
    unproject: function(t) {
      return r(t), q(l(t));
    }
  };
  var B = {
      __proto__: null,
      project: function(t) {
        return r(t), p(N(t));
      },
      unproject: function(t) {
        return r(t), q(d(t));
      }
    },
    G = n.default.bounds([42e4, 3e4], [9e5, 35e4]),
    k = n.default.bounds([242e4, 103e4], [29e5, 135e4]);
  function F(t, a) {
    return {
      bounds: a,
      project: function(a) {
        var e = a.lng,
          o = a.lat,
          r = t.project([e, o]),
          i = r[0],
          s = r[1];
        return n.default.point(i, s);
      },
      unproject: function(a) {
        var e = a.x,
          o = a.y,
          r = t.unproject([e, o]),
          i = r[0],
          s = r[1];
        return n.default.latLng(s, i);
      }
    };
  }
  var R = F(z, G),
    Z = F(B, k),
    A = [
      4e3,
      3750,
      3500,
      3250,
      3e3,
      2750,
      2500,
      2250,
      2e3,
      1750,
      1500,
      1250,
      1e3,
      750,
      650,
      500,
      250,
      100,
      50,
      20,
      10,
      5,
      2.5,
      2,
      1.5,
      1,
      0.5,
      0.25,
      0.1
    ];
  var H = n.default.Class.extend({
      includes: n.default.CRS,
      initialize: function(t) {
        (this.code = t.code), (this.projection = t.projection);
        var a = this.projection.bounds.getBottomLeft();
        (this.transformation = new n.default.Transformation(1, -a.x, -1, a.y)),
          (this.infinite = !1);
      },
      scale: function(t) {
        return (
          1 /
          (function(t) {
            if (t < 0) return A[0];
            if (t > A.length - 1) return A[A.length - 1];
            var a = Math.floor(t);
            if (a === t) return A[t];
            var n = A[a],
              e = A[a + 1] / n;
            return n * Math.pow(e, t - a);
          })(t)
        );
      },
      zoom: function(t) {
        return (function(t) {
          for (var a = -1, n = 0; n < A.length; n += 1)
            if (t >= A[n]) {
              a = n;
              break;
            }
          if (0 === a) return 0;
          if (-1 === a) return A.length - 1;
          if (A[a] === t) return a;
          var e = A[a - 1],
            o = A[a];
          return a + Math.log(o / t) / Math.log(e / o);
        })(1 / t);
      },
      distance: function(t, a) {
        var n = this.project(t),
          e = this.project(a);
        return n.distanceTo(e);
      }
    }),
    O = new H({ code: e, projection: R }),
    D = new H({ code: o, projection: Z }),
    J = n.default.latLngBounds(
      D.unproject(D.projection.bounds.min),
      D.unproject(D.projection.bounds.max)
    ),
    K = n.default.latLngBounds(
      D.unproject(n.default.point(2485e3, 1075e3)),
      D.unproject(n.default.point(2835e3, 1295e3))
    ),
    Q = {
      "EPSG:21781":
        "https://wmts{s}.geo.admin.ch/1.0.0/{layer}/default/{timestamp}/21781/{z}/{y}/{x}.{format}",
      "EPSG:2056":
        "https://wmts{s}.geo.admin.ch/1.0.0/{layer}/default/{timestamp}/2056/{z}/{x}/{y}.{format}"
    },
    U = n.default.TileLayer.extend({
      options: {
        attribution:
          '© <a href="https://www.swisstopo.ch/" target="_blank">Swisstopo</a>',
        bounds: J,
        crs: D,
        format: "jpeg",
        layer: "ch.swisstopo.pixelkarte-farbe",
        minZoom: 14,
        maxNativeZoom: 27,
        maxZoom: 28,
        subdomains: "0123456789",
        timestamp: "current"
      },
      initialize: function(t) {
        n.default.setOptions(this, t);
        var a = this.options.url || Q[this.options.crs.code];
        n.default.TileLayer.prototype.initialize.call(this, a, this.options);
      }
    });
  return (
    (n.default.CRS.EPSG21781 = O),
    (n.default.CRS.EPSG2056 = D),
    (n.default.TileLayer.Swiss = U),
    (n.default.tileLayer.swiss = function(t) {
      return new U(t);
    }),
    n.default.Map.addInitHook(function() {
      this.options.maxBounds ||
        (this.options.crs !== O && this.options.crs !== D) ||
        this.setMaxBounds(J);
    }),
    n.default.Map.include({
      fitSwitzerland: function() {
        this.fitBounds(K);
      }
    }),
    U
  );
});
//# sourceMappingURL=Leaflet.TileLayer.Swiss.umd.js.map
