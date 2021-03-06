<?xml version="1.0" encoding="UTF-8"?>

<!--
fr.xsl
Parameters for French resumes.

Copyright (c) 2001-2002 Sean Kelly
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$Id: fr.xsl,v 1.5 2002/11/18 21:04:25 brandondoyle Exp $
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- French language notes (correct us if we're wrong:
 * Not all the words are capitalized in titles, only the first one. 
 * It's T?l?phone priv?, not priv? T?l?phone
-->

  <xsl:param name="resume.word">Curriculum Vitae</xsl:param>
  <xsl:param name="page.word">page</xsl:param>
  <xsl:param name="contact.word">Information de Contact</xsl:param>
  <xsl:param name="objective.word">Objectif professionnel</xsl:param>
  <xsl:param name="history.word">Exp&#x00e9;rience professionnelle</xsl:param>
  <xsl:param name="academics.word">Formation</xsl:param>
  <xsl:param name="publications.word">Publications</xsl:param>
  <xsl:param name="miscellany.word">Divers</xsl:param>
  <xsl:param name="in.word">en</xsl:param>
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <xsl:param name="by.word">par</xsl:param>
  <xsl:param name="present.word">pr&#x00e9;sent</xsl:param>

  <xsl:param name="phone.word">T&#x00e9;l&#x00e9;phone</xsl:param>
  <xsl:param name="fax.word">Facsimile</xsl:param>
  <xsl:param name="phone.mobile.phrase">GSM</xsl:param> 
  <xsl:param name="phone.home.phrase"><xsl:value-of select="$phone.word"/> priv&#x00e9;</xsl:param>
  <xsl:param name="fax.home.phrase"><xsl:value-of select="$fax.word"/> priv&#x00e9;</xsl:param>

  <xsl:param name="email.word">Courrier &#x00e9;lectronique</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>
  <xsl:param name="achievements.word">R&#x00e9;alisations:</xsl:param>
  <xsl:param name="projects.word">Projets:</xsl:param>
  <xsl:param name="referees.word">R&#x00e9;f&#x00e9;rences</xsl:param>
  <xsl:param name="awards.word">R&#x00e9;compenses</xsl:param>

  <!-- default is European address formatting.  For countries other -->
  <!-- than France (e.g. Canada) "standard" formatting may be more correct. -->
  <xsl:param name="address.format">european</xsl:param>

  <xsl:param name="and.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="fax.work.phrase">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.aim.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.icq.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.irc.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.jabber.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.msn.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.yahoo.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="interests.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="last-modified.phrase">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="major-gpa.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="minor.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="minors.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="out-of.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="overall-gpa.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="pager.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="phone.work.phrase">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="referees.hidden.phrase">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="security-clearances.word">TRANSLATION NEEDED</xsl:param>
</xsl:stylesheet>

