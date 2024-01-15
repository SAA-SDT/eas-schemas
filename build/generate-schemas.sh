#!/bin/bash

set -eo pipefail

# needs to be run from within the build directory for now.
saxon="../vendor/SaxonHE10-1J/saxon-he-10.1.jar"
jing="../vendor/jing-20181222/bin/jing.jar"
trang="../vendor/trang-20091111/trang.jar"

# add a flag for the filename postfix, e.g. -4-dev... for now just hardcoded while testing.

echo "Getting started."

java -cp $saxon net.sf.saxon.Transform -t -xsl:transformations/prep-source-schema-files.xsl -it

java -jar $jing -s ../src/modules/extensible-version/ead/ead-source.rng > ../xml-schemas/ead/ead-4-dev.rng

java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/ead/ead-4-dev.rng -xsl:transformations/add-comments-and-metadata.xsl -o:../xml-schemas/ead/ead-4-dev.rng

java -jar $trang -o disable-abstract-elements -o any-process-contents=lax -o any-attribute-process-contents=lax ../xml-schemas/ead/ead-4-dev.rng ../xml-schemas/ead/ead-4-dev.xsd

java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/ead/ead-4-dev.xsd -xsl:transformations/deglobalize-xsd.xsl -o:../xml-schemas/ead/ead-4-dev.xsd

java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/ead/ead-4-dev.xsd -xsl:transformations/update-namespace-prefix-in-xsd.xsl -o:../xml-schemas/ead/ead-4-dev.xsd


echo "All done."
