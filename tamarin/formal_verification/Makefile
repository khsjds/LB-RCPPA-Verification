SOURCES= $(shell ls *.proppp)
TARGETS= $(SOURCES:.proppp=.spthy)
#CPP=gcc -E # cpp instead of gcc -E  works on Linux, but misbehaves on Mac OS X

default: $(TARGETS) 

%.spthy: %.proppp 
## Easy ways of preprocessing the files would be
#	$(CPP) -x assembler-with-cpp -P -C -o $@  $<
# but the above is a cludge. m4 is the right tool, but
#	m4 $< > $@
# might interpret some unintended parts of the file or swallow some quotes. 
# To make sure that no commands are accidentally invoked, the code below first prepends 
# everything with a # which is a comment in m4. Then the #include keyword is replaced
# by the undivert(`...') command (in two steps because of the closing backtick)
# Then a newline is appended, because m4 does not like the file to end with a comment.
# Finally, the file is processed with m4 and the leading # are stripped.
	@cat $< | sed -e 's/^/#/' -e 's/#[ ]*#include "\(.*\)"/undivert(\`\1)/' | sed -e "/undivert/s/)/')/" > $<.temp
	@echo " " >> $<.temp 
	@m4 $<.temp | sed -e 's/^#//' > $@
	@rm -f $<.temp
	cpp -w -C -P $< $@

clean:
	rm -f *~ *.temp
	rm -f $(TARGETS)

