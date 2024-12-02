lib/fysk/parser.rb: fysk.y
	bundle exec racc $< -o $@

.PHONY: clean
clean:
	rm -f lib/fysk/parser.*
