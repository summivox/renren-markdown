// Generated by CoffeeScript 1.6.2
/*!
https://github.com/smilekzs/lru-minimal/
!
*/


(function() {
  var Lru, SMap,
    __hasProp = {}.hasOwnProperty;

  SMap = (function() {
    var bailout, esc, str, unesc;

    str = function(k) {
      return k != null ? k.toString() : void 0;
    };
    esc = function(s) {
      return '\0' + s;
    };
    unesc = function(s) {
      return s.slice(1);
    };
    bailout = function() {
      throw Error('SMap: invalid key');
    };
    return SMap = (function() {
      function SMap() {
        this.clear();
      }

      SMap.prototype.clear = function() {
        this.o = {};
        this.size = 0;
      };

      SMap.prototype.set = function(k, v) {
        var ek, ret, sk;

        if ((sk = str(k)) == null) {
          bailout();
        }
        ek = esc(sk);
        if (ret = !(ek in this.o)) {
          ++this.size;
        }
        this.o[ek] = v;
        return ret;
      };

      SMap.prototype.get = function(k) {
        var sk;

        if ((sk = str(k)) == null) {
          bailout();
        }
        return this.o[esc(sk)];
      };

      SMap.prototype.has = function(k) {
        return this.get(k) != null;
      };

      SMap.prototype["delete"] = function(k) {
        var ek, ret, sk;

        if ((sk = str(k)) == null) {
          bailout();
        }
        ek = esc(sk);
        if (ret = ek in this.o) {
          --this.size;
          delete this.o[ek];
        }
        return ret;
      };

      SMap.prototype.forEach = function(cb) {
        var ek, sk, v, _ref;

        _ref = this.o;
        for (ek in _ref) {
          if (!__hasProp.call(_ref, ek)) continue;
          v = _ref[ek];
          sk = unesc(ek);
          cb(sk, v);
        }
      };

      SMap.prototype.toArray = function(cb) {
        var ek, sk, v, _ref, _results;

        _ref = this.o;
        _results = [];
        for (ek in _ref) {
          if (!__hasProp.call(_ref, ek)) continue;
          v = _ref[ek];
          sk = unesc(ek);
          _results.push([sk, v]);
        }
        return _results;
      };

      return SMap;

    })();
  })();

  Lru = (function() {
    var bump, insert, link, unlink;

    insert = function(p, n, k, v) {
      var x;

      link(p, n, x = {
        p: p,
        n: n,
        k: k,
        v: v
      });
      return x;
    };
    link = function(p, n, x) {
      x.p = p;
      x.n = n;
      p.n = n.p = x;
      return x;
    };
    unlink = function(x) {
      x.p.n = x.n;
      x.n.p = x.p;
      return x;
    };
    bump = function(x, head) {
      unlink(x);
      return link(head, head.n, x);
    };
    return Lru = (function() {
      function Lru(cap) {
        this.cap = cap;
        this.clear();
      }

      Lru.prototype.clear = function() {
        this.map = new SMap();
        this.size = 0;
        this.head = {
          p: null,
          n: null,
          k: null,
          v: null
        };
        this.tail = {
          p: null,
          n: null,
          k: null,
          v: null
        };
        this.head.n = this.tail;
        return this.tail.p = this.head;
      };

      Lru.prototype.set = function(k, v) {
        var x;

        if (x = this.map.get(k)) {
          bump(x, this.head);
          x.k = k;
          x.v = v;
          return false;
        } else {
          if (this.map.size >= this.cap) {
            this.shift();
          }
          x = insert(this.head, this.head.n, k, v);
          this.map.set(k, x);
          this.size = this.map.size;
          return true;
        }
      };

      Lru.prototype.get = function(k) {
        var x;

        if (x = this.map.get(k)) {
          bump(x, this.head);
          return x.v;
        }
      };

      Lru.prototype.has = function(k) {
        return this.get(k) != null;
      };

      Lru.prototype["delete"] = function(k) {
        var x;

        if (x = this.map.get(k)) {
          unlink(x);
          this.map["delete"](k);
          this.size = this.map.size;
          return true;
        } else {
          return false;
        }
      };

      Lru.prototype.shift = function() {
        var x;

        x = this.tail.p;
        if (!x.p) {
          return;
        }
        unlink(x);
        this.map["delete"](x.k);
        this.size = this.map.size;
        return [x.k, x.v];
      };

      Lru.prototype.forEach = function(cb) {
        var x, _results;

        x = this.head.n;
        _results = [];
        while (x.n) {
          cb(x.k, x.v);
          _results.push(x = x.n);
        }
        return _results;
      };

      Lru.prototype.toArray = function(cb) {
        var ret, x;

        ret = [];
        x = this.head.n;
        while (x.n) {
          ret.push([x.k, x.v]);
          x = x.n;
        }
        return ret;
      };

      return Lru;

    })();
  })();

  (function(exp) {
    exp.SMap = SMap;
    return exp.Lru = Lru;
  })((function() {
    switch (false) {
      case !(typeof module !== "undefined" && module !== null ? module.exports : void 0):
        return module.exports;
      case typeof window === "undefined" || window === null:
        return window;
    }
  })());

}).call(this);