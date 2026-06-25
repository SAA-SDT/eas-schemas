#!/bin/bash

set -eo pipefail

# needs to be run from within the build directory for now.
saxon="../vendor/SaxonHE10-1J/saxon-he-10.1.jar"
jing="../vendor/jing-20181222/bin/jing.jar"
trang="../vendor/trang-20091111/trang.jar"

# later, add an option for ALL, ead, eac, or eaf.
# for now, just run them all, since we want to make sure nothing is / gets broken.
# add variables for the release number, e.g. ead-4-0; eac-cpf-3-0; eaf-1-0

# EAC-CPF
echo "Getting started. First up, the EAC transformation:"
java -cp $saxon net.sf.saxon.Transform -t -xsl:transformations/prep-source-schema-files.xsl -it schema='eac'
java -jar $jing -s ../src/modules/extensible-version/eac/eac-source.rng > ../xml-schemas/eac-cpf/eac.rng
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/eac-cpf/eac.rng -xsl:transformations/add-comments-and-metadata.xsl -o:../xml-schemas/eac-cpf/eac.rng schema='eac'
java -jar $trang -o disable-abstract-elements -o any-process-contents=lax -o any-attribute-process-contents=lax ../xml-schemas/eac-cpf/eac.rng ../xml-schemas/eac-cpf/eac.xsd
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/eac-cpf/eac.xsd -xsl:transformations/deglobalize-xsd.xsl -o:../xml-schemas/eac-cpf/eac.xsd schema='eac'
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/eac-cpf/eac.xsd -xsl:transformations/update-namespace-prefix-in-xsd.xsl -o:../xml-schemas/eac-cpf/eac.xsd schema='eac'

# EAD
echo "Next, the EAD transformation:"
java -cp $saxon net.sf.saxon.Transform -t -xsl:transformations/prep-source-schema-files.xsl -it schema='ead'
java -jar $jing -s ../src/modules/extensible-version/ead/ead-source.rng > ../xml-schemas/ead/ead.rng
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/ead/ead.rng -xsl:transformations/add-comments-and-metadata.xsl -o:../xml-schemas/ead/ead.rng schema='ead'
java -jar $trang -o disable-abstract-elements -o any-process-contents=lax -o any-attribute-process-contents=lax ../xml-schemas/ead/ead.rng ../xml-schemas/ead/ead.xsd
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/ead/ead.xsd -xsl:transformations/deglobalize-xsd.xsl -o:../xml-schemas/ead/ead.xsd schema='ead'
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/ead/ead.xsd -xsl:transformations/update-namespace-prefix-in-xsd.xsl -o:../xml-schemas/ead/ead.xsd schema='ead'

# EAF
echo "And last (but not least), the EAF transformation:"
java -cp $saxon net.sf.saxon.Transform -t -xsl:transformations/prep-source-schema-files.xsl -it schema='eaf'
java -jar $jing -s ../src/modules/extensible-version/eaf/eaf-source.rng > ../xml-schemas/eaf/eaf.rng
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/eaf/eaf.rng -xsl:transformations/add-comments-and-metadata.xsl -o:../xml-schemas/eaf/eaf.rng schema='eaf'
java -jar $trang -o disable-abstract-elements -o any-process-contents=lax -o any-attribute-process-contents=lax ../xml-schemas/eaf/eaf.rng ../xml-schemas/eaf/eaf.xsd
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/eaf/eaf.xsd -xsl:transformations/deglobalize-xsd.xsl -o:../xml-schemas/eaf/eaf.xsd schema='eaf'
java -cp $saxon net.sf.saxon.Transform -s:../xml-schemas/eaf/eaf.xsd -xsl:transformations/update-namespace-prefix-in-xsd.xsl -o:../xml-schemas/eaf/eaf.xsd schema='eaf'

echo "All done."
