@echo off

set parameters=-Xmx1024m
set CP=-cp ..\vendor\SaxonHE10-1J\saxon-he-10.1.jar
set jing=..\vendor\jing-20181222\bin\jing.jar
set trang=..\vendor\trang-20091111\trang.jar

:: check if Java is installed
where java >nul 2>nul
if %errorlevel%==1 (
    @echo Java not found in path.
    exit
)


rem still need to update for when we switch between EAD / EAC transformations, which we can do by passing parameters
rem now just hard-coded for EAD

rem add a flag for the filename postfix, e.g. -4-dev... for now just hardcoded while testing.

@echo Getting started.

java %parameters% %CP% net.sf.saxon.Transform -t -xsl:transformations\prep-source-schema-files.xsl -it

java -jar %jing% -s ..\src\modules\extensible-version\ead\ead-source.rng > ..\xml-schemas\ead\ead-4-dev.rng

java %parameters% %CP% net.sf.saxon.Transform -s:..\xml-schemas\ead\ead-4-dev.rng -xsl:transformations\add-comments-and-metadata.xsl -o:..\xml-schemas\ead\ead-4-dev.rng -warnings:silent

java -jar %trang% -o disable-abstract-elements -o any-process-contents=lax -o any-attribute-process-contents=lax ..\xml-schemas\ead\ead-4-dev.rng ..\xml-schemas\ead\ead-4-dev.xsd

java %parameters% %CP% net.sf.saxon.Transform -s:..\xml-schemas\ead\ead-4-dev.xsd -xsl:transformations\deglobalize-xsd.xsl -o:..\xml-schemas\ead\ead-4-dev.xsd -warnings:silent

java %parameters% %CP% net.sf.saxon.Transform -s:..\xml-schemas\ead\ead-4-dev.xsd -xsl:transformations\update-namespace-prefix-in-xsd.xsl -o:..\xml-schemas\ead\ead-4-dev.xsd -warnings:silent

@echo All done.

pause
