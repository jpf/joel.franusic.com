EMACS ?= emacs

.PHONY: publish clean

# Regenerate the blog (posts/*.org -> *.html, posts.html, archive.html,
# tags.html, rss.xml) at the repo root. Requires Emacs 27+; no other
# dependencies (org-static-blog.el is vendored in elisp/).
publish:
	$(EMACS) --batch -Q -l elisp/publish.el --eval "(org-static-blog-publish t)"

# Remove generated blog output (the *.html files org-static-blog wrote
# next to each posts/*.org file, plus the index/archive/tags/rss pages).
# Does not touch hand-written pages like index.html or contact/.
clean:
	@for f in $$(find posts -name '*.org'); do \
		rel=$${f#posts/}; \
		rel=$${rel%.org}.html; \
		[ -f "$$rel" ] && echo "rm $$rel" && rm "$$rel"; \
	done
	rm -f posts.html archive.html tags.html rss.xml tag-*.html
