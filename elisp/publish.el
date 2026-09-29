;;; publish.el --- org-static-blog configuration for joel.franusic.com  -*- lexical-binding: t; -*-

;; Run this non-interactively with:
;;
;;   emacs --batch -Q -l elisp/publish.el --eval "(org-static-blog-publish t)"
;;
;; or just `make publish` (see the Makefile in the repo root).
;;
;; Or interactively, from within Emacs: `M-x load-file' this file (once
;; per session), then `M-x org-static-blog-publish' to rebuild the whole
;; blog, or `M-x org-static-blog-publish-file' while visiting a post to
;; publish just that one post. Paths below are resolved relative to
;; this file's own location, not `default-directory', so this works
;; the same whether it's loaded in batch mode or from any buffer.
;;
;; This only manages the blog (the .org files in posts/, published as
;; flat *.html files at the repo root). Everything else on the site
;; (index.html, contact/, krazy_kat/, virgil/, ...) is hand-written
;; static HTML and is untouched by this script.

(defvar joel-blog-root
  (expand-file-name ".." (file-name-directory (or load-file-name buffer-file-name)))
  "Root directory of the joel.franusic.com repo.")

(add-to-list 'load-path (expand-file-name "elisp" joel-blog-root))
(require 'org-static-blog)

;; --- Basic site settings -----------------------------------------------

(setq org-static-blog-publish-title "Joël Franusic")
(setq org-static-blog-publish-url "https://joel.franusic.com/")
(setq org-static-blog-publish-directory (file-name-as-directory joel-blog-root))
(setq org-static-blog-posts-directory (expand-file-name "posts/" joel-blog-root))
(setq org-static-blog-drafts-directory (expand-file-name "drafts/" joel-blog-root))
(setq org-static-blog-langcode "en")

;; No auto-numbered headlines ("1. Foo", "3.2. Bar") and no auto-inserted
;; table of contents on posts. A post can still opt back in with its own
;; #+OPTIONS: toc:t num:t line, which overrides these defaults.
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)

;; Don't clobber the hand-written homepage (index.html) or the pretty
;; permalinks preserved from the old Jekyll site: the blog's own
;; generated index/archive/tag/RSS pages live at these names instead.
(setq org-static-blog-index-file "posts.html")
(setq org-static-blog-archive-file "archive.html")
(setq org-static-blog-tags-file "tags.html")
(setq org-static-blog-rss-file "rss.xml")
(setq org-static-blog-index-length 5)

(setq org-static-blog-enable-tags t)
(setq org-static-blog-enable-og-tags t)

;; Show only the first paragraph + a "read more" link on the multi-post
;; index/archive/tag pages, rather than the full text of every post
;; (some of these posts, e.g. book-notes ones, are very long).
(setq org-static-blog-use-preview t)
(setq org-static-blog-preview-link-p t)
(setq org-static-blog-preview-ellipsis " (Read more…)")

;; Work around an org-static-blog quirk (still present as of 1.7.0):
;; `org-static-blog-get-preview' builds the per-post taglist with
;; `format "%s"', which prints the literal string "nil" for posts that
;; have no tags. Patch the output rather than the vendored file.
(advice-add 'org-static-blog-get-preview :filter-return
            (lambda (html)
              (replace-regexp-in-string
               "<div class=\"taglist\">nil</div>" "<div class=\"taglist\"></div>" html)))

;; --- Look and feel -------------------------------------------------------
;; Re-uses the site's existing Bootstrap CSS for a consistent look, but
;; keeps the template itself simple (a single-column post view) rather
;; than trying to recreate the old Jekyll layouts.

(setq org-static-blog-page-header
      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
<meta name=\"author\" content=\"Joël Franusic\">
<link href=\"/css/bootstrap.css\" rel=\"stylesheet\">
<link href=\"/css/bootstrap-responsive.css\" rel=\"stylesheet\">
<link rel=\"shortcut icon\" href=\"/favicon.ico\">
<style>
  body { padding-top: 60px; }
  #content { max-width: 760px; margin: 0 auto; padding: 0 20px 40px; }
  #postamble { max-width: 760px; margin: 0 auto; padding: 0 20px; color: #777; }
  .post-date { color: #999; font-size: 0.9em; margin-top: 1.5em; }
  .post-title a { color: inherit; text-decoration: none; }
  .taglist { margin-top: 2em; }
  .tag, .tag-label { display: inline-block; margin-right: 6px; padding: 2px 8px;
    background: #f5f5f5; border-radius: 4px; font-size: 0.85em; }
  img { max-width: 100%; height: auto; }
</style>")

(setq org-static-blog-page-preamble
      "<div class=\"navbar navbar-inverse navbar-fixed-top\">
  <div class=\"navbar-inner\">
    <div class=\"container-fluid\">
      <a class=\"brand\" href=\"/\">Joël Franusic</a>
      <div class=\"nav-collapse collapse\">
        <ul class=\"nav\">
          <li><a href=\"/posts.html\">Blog</a></li>
          <li><a href=\"/archive.html\">Archive</a></li>
          <li><a href=\"/contact/\">Contact</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>")

(setq org-static-blog-page-postamble
      "<hr>
<footer><p>Copyright © 2013-2026 Joël Franusic</p></footer>")

;;; publish.el ends here
