# Wunschgäste – statische Website

Eine 1:1-Nachbildung der Gamma-Seite als eigenständige, statische Website.
Kein Baukasten, kein CMS, keine Datenbank – nur HTML, CSS und ein paar Kilobyte
JavaScript. Damit ist sie schnell, günstig zu hosten und vollständig in deiner Hand.

---

## 1. Hochladen

Den **gesamten Inhalt** dieses Ordners in das Web-Verzeichnis deines Hosters
kopieren (bei den meisten Anbietern heißt es `httpdocs`, `public_html` oder `www`).
Wichtig: die Dateien selbst hochladen, **nicht** den Ordner `wunschgaeste-website`.

Danach ist die Seite unter `https://wunschgaeste.de/` erreichbar.

### Vorher lokal anschauen

Einfach `index.html` doppelklicken – alle Pfade sind relativ, die Seite
funktioniert also auch direkt von der Festplatte. Nur zwei Kleinigkeiten
verhalten sich offline anders als später auf dem Server:

- Die Schriften kommen von Google Fonts und brauchen eine Internetverbindung.
  Ohne Netz greift die eingebaute Reserve-Schrift.
- `site.webmanifest` und `.htaccess` sind reine Server-Angelegenheiten und
  bleiben lokal wirkungslos.

> Die versteckte Datei `.htaccess` unbedingt mit hochladen – manche FTP-Programme
> blenden Dateien mit führendem Punkt aus. In FileZilla:
> *Server → Versteckte Dateien anzeigen erzwingen*.

---

## 2. Domains

| Domain | Rolle | Was passieren soll |
|---|---|---|
| `wunschgaeste.de` | **Hauptdomain** | Hier liegt die Seite. Kanonische Adresse. |
| `wunschgäste.de` (= `xn--wunschgste-r8a.de`) | Nebendomain | 301-Weiterleitung auf die Hauptdomain |
| `www.wunschgaeste.de` | Nebenform | 301-Weiterleitung auf die Hauptdomain |

Die Weiterleitungen erledigt die mitgelieferte `.htaccess` automatisch (Apache).
Beide Domains müssen im Hosting-Paket auf **dasselbe** Verzeichnis zeigen.

**Warum weiterleiten und nicht beide Domains parallel betreiben?**
Google wertet zwei identische Seiten als Duplicate Content – die Rankings
verteilen sich dann auf zwei Adressen statt sich auf einer zu bündeln. Mit der
301-Weiterleitung fließt die gesamte Kraft auf `wunschgaeste.de`.
Die Umlautdomain bleibt trotzdem voll nutzbar: Wer `wunschgäste.de` eintippt oder
auf Visitenkarten liest, landet direkt auf der richtigen Seite.

Die Umlautdomain ist zusätzlich in den strukturierten Daten als `sameAs`
hinterlegt, damit Google beide Schreibweisen demselben Unternehmen zuordnet.

### Bei nginx statt Apache

`.htaccess` wird dort ignoriert. Stattdessen in den Server-Block:

```nginx
server {
    server_name www.wunschgaeste.de xn--wunschgste-r8a.de www.xn--wunschgste-r8a.de;
    return 301 https://wunschgaeste.de$request_uri;
}
```

### Bei Netlify / Vercel / Cloudflare Pages

Dort im Dashboard `wunschgaeste.de` als *Primary Domain* setzen; die anderen
Domains werden automatisch dorthin weitergeleitet. Zusätzlich eine Datei
`_redirects` mit dem Inhalt `/*  /index.html  200` anlegen.

---

## 3. Nach dem Hochladen: drei Minuten für die Sichtbarkeit

1. **Google Search Console** (kostenlos): Property `https://wunschgaeste.de`
   anlegen, Inhaberschaft per DNS-Eintrag bestätigen, dann
   `https://wunschgaeste.de/sitemap.xml` einreichen.
   Danach unter *URL-Prüfung* die Startseite einreichen – das beschleunigt die
   Aufnahme in den Index von Wochen auf Tage.
2. **Google Unternehmensprofil** anlegen (Dresden, Dienstleistung im Einzugsgebiet
   „Deutschland"). Für lokale Suchanfragen ist das der stärkste einzelne Hebel –
   deutlich wirksamer als jede Änderung an der Seite selbst.
3. **Bing Webmaster Tools**: Import aus der Search Console mit einem Klick.
   Bing speist auch die Suche in ChatGPT und Copilot.

---

## 4. Was für SEO schon eingebaut ist

- Sprechender, keyword-starker `<title>` und eine Meta-Description mit Handlungsaufruf
- Eine einzige `<h1>`, saubere Überschriften-Hierarchie darunter
- `canonical`, `hreflang`, `robots`-Angaben, `sitemap.xml`, `robots.txt`
- Strukturierte Daten (JSON-LD): `ProfessionalService` / `LocalBusiness` mit
  Adresse, Telefon, E-Mail und Leistungen, dazu `WebSite` und `FAQPage`
  → Die FAQ können als aufklappbare Treffer direkt in den Google-Ergebnissen erscheinen
- Open Graph und Twitter Cards inklusive Vorschaubild (`og-image.jpg`) –
  sorgt für ordentliche Vorschauen in WhatsApp, Facebook, LinkedIn
- Geo-Angaben für Dresden, `areaServed: Deutschland`
- Alle Bilder mit aussagekräftigen `alt`-Texten, `width`/`height` gegen Layout-Sprünge,
  WebP mit JPEG-Rückfallebene, `srcset` für Retina-Displays
- Bilder unterhalb des sichtbaren Bereichs werden verzögert geladen (`loading="lazy"`),
  das Hero-Bild bevorzugt (`fetchpriority="high"`)
- Komprimierung, Browser-Caching und Sicherheits-Header in der `.htaccess`
- KI-Crawler (GPTBot, PerplexityBot, ClaudeBot …) in `robots.txt` ausdrücklich erlaubt
- Barrierefreiheit: Sprungmarke, Tastaturbedienung, sichtbarer Fokus, ARIA-Beschriftungen –
  fließt seit einiger Zeit auch in die Bewertung ein

---

## 5. Schriften – optional selbst hosten

Die Seite verwendet dieselben Schriften wie das Original:
**Bricolage Grotesque** (Überschriften) und **Inter** (Fließtext). Sie werden
aktuell über Google Fonts geladen; darum steht ein entsprechender Absatz in der
Datenschutzerklärung.

Wenn du ganz ohne Google auskommen willst – in Deutschland die sicherere Variante –
lade die Schriften einmalig auf deinen eigenen Server:

```bash
chmod +x fonts-selbst-hosten.sh
./fonts-selbst-hosten.sh
```

Das Skript legt die Dateien in `assets/fonts/` ab und sagt dir am Ende, welche
drei Zeilen du danach noch anpassen musst. Beide Schriften stehen unter der
SIL Open Font License und dürfen selbst gehostet werden.

Als Notfall-Reserve liegen bereits minimale Schnitte in `assets/fonts/`. Sie
greifen nur, falls Google Fonts einmal nicht erreichbar ist.

---

## 6. Inhalte ändern

Alles steht direkt in `index.html` – gut lesbar, mit Kommentaren in Abschnitte
gegliedert. Zum Ändern reicht ein Texteditor.

**Wichtig:** Wenn du Texte in den FAQ oder die Kontaktdaten änderst, passe sie
auch im JSON-LD-Block ganz oben in `index.html` an (Suchbegriff: `FAQPage` bzw.
`telephone`). Sonst weicht das, was Google liest, von dem ab, was Besucher sehen.

Farben, Abstände und Schriftgrößen sind in `assets/css/style.css` ganz oben als
Variablen definiert (`:root { … }`) – eine Änderung dort wirkt auf die ganze Seite.

---

## 7. Dateiübersicht

```
index.html                  die komplette Seite
.htaccess                   Weiterleitungen, Sicherheit, Caching (Apache)
robots.txt                  Crawler-Regeln
sitemap.xml                 Sitemap für Google
site.webmanifest            Angaben für „Zum Startbildschirm hinzufügen"
favicon.ico, favicon-32.png Symbole für den Browser-Tab (goldene Maske aus dem Logo)
icon-192/512.png            Symbole für den Startbildschirm
icon-512-maskable.png       Android-Variante mit Sicherheitsabstand
apple-touch-icon.png        Symbol für iOS (auf cremefarbenem Grund)
fonts-selbst-hosten.sh      Skript zum Selbst-Hosten der Schriften
assets/css/style.css        das gesamte Design
assets/fonts/               Notfall-Schriften
assets/img/                 alle Bilder (WebP + JPEG), inkl. logo.png/​.webp
```

---

## 8. Zwei Dinge, die du noch prüfen solltest

- **Impressum:** Falls für die Tätigkeit eine Umsatzsteuer-Identifikationsnummer
  vorliegt, gehört sie ins Impressum. Ebenso ein Hinweis auf die
  EU-Streitschlichtungsplattform, falls Verbraucherverträge geschlossen werden.
  Der Text wurde unverändert von der Gamma-Seite übernommen.
- **Haftpflichtversicherung:** Die FAQ nennt eine bestehende Haftpflichtversicherung.
  Diese Angabe sollte belegbar sein, da sie werblich verwendet wird.
