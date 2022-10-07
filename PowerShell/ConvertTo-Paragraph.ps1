<#
.SYNOPSIS
Converts a block of text into paragraphs, sentences, and words.

.EXAMPLE
"Ich gehe gerne einkaufen.
Nein, nicht shoppen. Ich spreche jetzt nicht von Sportschuhen, Jeans oder T-Shirts.
Ich meine Brot und Käse, Obst und Wein. Das kaufe ich sehr gerne, in den kleinen Läden in meiner Straße oder auf dem Markt." | ConvertTo-Paragraph

.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.2
#>

class Word {
    # [object] hidden $Foo = @{
    #     Bestimmter = '^d[a|e][inmrs]$'
    #     Einworten = '^[k]?ein(e|en|em|er|es)?$'
    # }

    [string]$Text
    [char[]]$Letters

    Word([string]$text) { $this.Text = $text; $this.Letters = $text.ToCharArray() | ForEach-Object { [char]$_ } }
}

<#
function New-Word {
    param (
        [Parameter(Position=0)]
        [string]$Text        
    )
    
    [Word]::new($Text)
}
#>

class Sentence {
    [string]$Text
    [Word[]]$Words

    Sentence([string]$text) { $this.Text = $text }
}

function New-Sentence {
    param (
        [Parameter(Position=0)]
        [string]$Text        
    )
    
    [Sentence]::new($Text)
}

class Paragraph {

    [string]$Text
    [Sentence[]]$Sentences

    Paragraph([string]$text) {
        $this.Text = $text

        $this.Parse()
    }

    Parse() {
        $DebugPreference = 'continue'
        #
        $Sentence = New-Sentence
        # $Sentence = [Sentence]::new($this.Text)

        $_ -split ' ' | ForEach-Object {

            $Token = $_
            $Sentence.Text += "$Token "

            if ($Token -match "(?'word'.*)(?'punc'(\.|\?|!))")
            {
                $Sentence.Words += $Matches['word']
                $Sentence.Words += $Matches['punc']
                $this.Sentences += $Sentence

                $Sentence = New-Sentence
                # $Sentence = [Sentence]::new($Text)
            }
            elseif ($Token -match "(?'word'.*)(?'punc'(,|:|;))")
            { 
                $Sentence.Words += $Matches['word']
                $Sentence.Words += $Matches['punc']
            }
            else
            {
                $Sentence.Words += $Token
            }

        }
    }

}

function New-Paragraph {
    param (
        [Parameter(Position=0,ValueFromPipeline)]
        [string]$Text
    )

    [Paragraph]::new($Text)
}

function ConvertTo-Paragraph {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$Text
    )
    
    process {

        $Text -split "`n" | Where-Object { ![string]::IsNullOrEmpty($_) } | ForEach-Object {

            Write-Verbose "Paragraph: $_"

            # $_ | New-Paragraph
            $Paragraph = $_ | New-Paragraph
<#
            $Sentence = New-Sentence

            $_ -split ' ' | ForEach-Object {

                $Token = $_
                $Sentence.Text += "$Token "

                if ($Token -match "(?'word'.*)(?'punc'(\.|\?|!))")
                { 
                    $Sentence.Words += $Matches['word']
                    $Sentence.Words += $Matches['punc']
                    $Paragraph.Sentences += $Sentence

                    $Sentence = New-Sentence
                }
                elseif ($Token -match "(?'word'.*)(?'punc'(,|:|;))")
                { 
                    $Sentence.Words += $Matches['word']
                    $Sentence.Words += $Matches['punc']
                }
                else
                {
                    $Sentence.Words += $Token
                }

            }
#>
            $Paragraph
        }

    }
    
}

$text = "Ich gehe gerne einkaufen.

Nein, nicht shoppen. Ich spreche jetzt nicht von Sportschuhen, Jeans oder T-Shirts.
Ich meine Brot und Käse, Obst und Wein. Das kaufe ich sehr gerne, in den kleinen Läden in meiner Straße oder auf dem Markt. 
Ich weiß: Das ist nicht praktisch, nicht so billig und dauert oft sehr lange. Na und? Es macht Spaß. Ich kenne viele Leute, wir grüßen uns freundlich, wir reden über Wetter, Familie, Fußball. 
Smalltalk, ich weiß, aber es tut gut. So von Nachbar zu Nachbar, von Mensch zu Mensch."

# # $Text -split "`n" | Where-Object { ![string]::IsNullOrEmpty($_) } #| New-Paragraph #| Select-Object -first 1 -ExpandProperty Sentences
$Text | ConvertTo-Paragraph | ConvertTo-Json -Depth 5