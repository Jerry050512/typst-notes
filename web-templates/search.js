(function () {
  "use strict";

  function getRoot() {
    if (typeof path_to_root === "string") return path_to_root;
    const base = document.querySelector("base")?.getAttribute("href");
    if (base) return base.endsWith("/") ? base : base + "/";
    const parts = window.location.pathname.split("/").filter(Boolean);
    // 如果 URL 以 .html 结尾，去掉最后一级
    if (parts.length > 0 && parts[parts.length - 1].includes(".")) parts.pop();
    return parts.map(() => "../").join("") || "./";
  }

  function esc(s) {
    return String(s).replace(/[&<>"']/g, (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c])
    );
  }

  function snippet(body, ts) {
    const lower = body.toLowerCase();
    let pos = -1;
    for (const t of ts) {
      pos = lower.indexOf(t);
      if (pos >= 0) break;
    }
    if (pos < 0) return esc(body.slice(0, 120));

    const start = Math.max(0, pos - 50);
    const end = Math.min(body.length, pos + 110);
    return esc((start ? "…" : "") + body.slice(start, end) + (end < body.length ? "…" : ""));
  }

  function score(doc, ts) {
    const title = doc.title.toLowerCase();
    const body = doc.body.toLowerCase();
    let s = 0;
    for (const t of ts) {
      if (title.includes(t)) s += 20;
      if (body.includes(t)) s += 1;
    }
    return s;
  }

  function init() {
    const root = getRoot();

    const wrapper = document.getElementById("search-wrapper");
    const toggle = document.getElementById("search-toggle");
    const input = document.getElementById("searchbar");
    const resultsOuter = document.getElementById("searchresults-outer");
    const resultsHeader = document.getElementById("searchresults-header");
    const resultsList = document.getElementById("searchresults");

    if (!wrapper || !toggle || !input || !resultsOuter || !resultsHeader || !resultsList) return;

    // 替换搜索按钮和输入框，移除 shiroa 原生的监听器，避免冲突
    const newToggle = toggle.cloneNode(true);
    toggle.parentNode.replaceChild(newToggle, toggle);
    const newInput = input.cloneNode(true);
    input.parentNode.replaceChild(newInput, input);

    let docs = [];

    function showSearch(show) {
      if (show) {
        wrapper.classList.remove("hidden");
        resultsOuter.classList.toggle("hidden", !newInput.value.trim());
        newInput.focus();
      } else {
        wrapper.classList.add("hidden");
        resultsOuter.classList.add("hidden");
      }
      newToggle.setAttribute("aria-expanded", String(show));
    }

    function render(q) {
      const ts = q.toLowerCase().split(/\s+/).filter(Boolean);
      if (ts.length === 0) {
        resultsOuter.classList.add("hidden");
        return;
      }

      const results = docs
        .map((d) => ({ d, s: score(d, ts) }))
        .filter((x) => x.s > 0)
        .sort((a, b) => b.s - a.s)
        .slice(0, 30);

      resultsHeader.textContent = results.length
        ? `${results.length} search results for '${q}':`
        : `No search results for '${q}'.`;

      resultsList.innerHTML = results
        .map(
          (x) =>
            `<li><a href="${esc(root + x.d.url.slice(1))}">${esc(x.d.title || x.d.url)}</a>` +
            `<span class="teaser">${snippet(x.d.body, ts)}</span></li>`
        )
        .join("");

      resultsOuter.classList.remove("hidden");
    }

    newToggle.addEventListener("click", () => showSearch(wrapper.classList.contains("hidden")));
    newInput.addEventListener("input", () => render(newInput.value.trim()));

    document.addEventListener("keydown", (e) => {
      if (
        !e.ctrlKey &&
        !e.metaKey &&
        !e.altKey &&
        e.key.toLowerCase() === "s" &&
        document.activeElement !== newInput
      ) {
        e.preventDefault();
        showSearch(true);
      }
      if (e.key === "Escape") showSearch(false);
    });

    fetch(root + "searchindex.json")
      .then((r) => r.json())
      .then((j) => {
        docs = j.docs || [];
        if (newInput.value.trim()) render(newInput.value.trim());
      })
      .catch(() => {
        docs = (window.__typstNotesSearch && window.__typstNotesSearch.docs) || [];
        if (newInput.value.trim()) render(newInput.value.trim());
      });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
