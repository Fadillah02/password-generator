#Requires -Version 5.1
<#
.SYNOPSIS
    Password Generator GUI - Tanpa Install
.DESCRIPTION
    Generate password aman dengan GUI
.EXAMPLE
    .\password-generator.ps1
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Password Generator - Cyber Lab"
$form.Size = New-Object System.Drawing.Size(500, 450)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "PASSWORD GENERATOR"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::Cyan
$titleLabel.Size = New-Object System.Drawing.Size(460, 40)
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Password display
$passwordBox = New-Object System.Windows.Forms.TextBox
$passwordBox.Font = New-Object System.Drawing.Font("Consolas", 14)
$passwordBox.Size = New-Object System.Drawing.Size(440, 40)
$passwordBox.Location = New-Object System.Drawing.Point(20, 60)
$passwordBox.ReadOnly = $true
$passwordBox.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$passwordBox.ForeColor = [System.Drawing.Color]::Lime
$passwordBox.TextAlign = "Center"
$form.Controls.Add($passwordBox)

# Length label
$lengthLabel = New-Object System.Windows.Forms.Label
$lengthLabel.Text = "Password Length: 16"
$lengthLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lengthLabel.ForeColor = [System.Drawing.Color]::White
$lengthLabel.Size = New-Object System.Drawing.Size(200, 25)
$lengthLabel.Location = New-Object System.Drawing.Point(20, 110)
$form.Controls.Add($lengthLabel)

# Length slider
$lengthSlider = New-Object System.Windows.Forms.TrackBar
$lengthSlider.Minimum = 8
$lengthSlider.Maximum = 64
$lengthSlider.Value = 16
$lengthSlider.TickFrequency = 4
$lengthSlider.Size = New-Object System.Drawing.Size(440, 45)
$lengthSlider.Location = New-Object System.Drawing.Point(20, 135)
$lengthSlider.Add_ValueChanged({
    $lengthLabel.Text = "Password Length: $($lengthSlider.Value)"
})
$form.Controls.Add($lengthSlider)

# Checkboxes
$uppercaseBox = New-Object System.Windows.Forms.CheckBox
$uppercaseBox.Text = "Uppercase (A-Z)"
$uppercaseBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$uppercaseBox.ForeColor = [System.Drawing.Color]::White
$uppercaseBox.Checked = $true
$uppercaseBox.Size = New-Object System.Drawing.Size(200, 25)
$uppercaseBox.Location = New-Object System.Drawing.Point(20, 180)
$form.Controls.Add($uppercaseBox)

$lowercaseBox = New-Object System.Windows.Forms.CheckBox
$lowercaseBox.Text = "Lowercase (a-z)"
$lowercaseBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lowercaseBox.ForeColor = [System.Drawing.Color]::White
$lowercaseBox.Checked = $true
$lowercaseBox.Size = New-Object System.Drawing.Size(200, 25)
$lowercaseBox.Location = New-Object System.Drawing.Point(250, 180)
$form.Controls.Add($lowercaseBox)

$numbersBox = New-Object System.Windows.Forms.CheckBox
$numbersBox.Text = "Numbers (0-9)"
$numbersBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$numbersBox.ForeColor = [System.Drawing.Color]::White
$numbersBox.Checked = $true
$numbersBox.Size = New-Object System.Drawing.Size(200, 25)
$numbersBox.Location = New-Object System.Drawing.Point(20, 210)
$form.Controls.Add($numbersBox)

$symbolsBox = New-Object System.Windows.Forms.CheckBox
$symbolsBox.Text = "Symbols (!@#$%^&*)"
$symbolsBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$symbolsBox.ForeColor = [System.Drawing.Color]::White
$symbolsBox.Checked = $true
$symbolsBox.Size = New-Object System.Drawing.Size(200, 25)
$symbolsBox.Location = New-Object System.Drawing.Point(250, 210)
$form.Controls.Add($symbolsBox)

# Strength meter
$strengthLabel = New-Object System.Windows.Forms.Label
$strengthLabel.Text = "Strength: -"
$strengthLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$strengthLabel.ForeColor = [System.Drawing.Color]::White
$strengthLabel.Size = New-Object System.Drawing.Size(460, 25)
$strengthLabel.Location = New-Object System.Drawing.Point(20, 250)
$form.Controls.Add($strengthLabel)

$strengthBar = New-Object System.Windows.Forms.ProgressBar
$strengthBar.Size = New-Object System.Drawing.Size(440, 20)
$strengthBar.Location = New-Object System.Drawing.Point(20, 275)
$strengthBar.Style = "Continuous"
$form.Controls.Add($strengthBar)

# Generate button
$generateBtn = New-Object System.Windows.Forms.Button
$generateBtn.Text = "GENERATE"
$generateBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$generateBtn.Size = New-Object System.Drawing.Size(210, 45)
$generateBtn.Location = New-Object System.Drawing.Point(20, 310)
$generateBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$generateBtn.ForeColor = [System.Drawing.Color]::White
$generateBtn.FlatStyle = "Flat"
$form.Controls.Add($generateBtn)

# Copy button
$copyBtn = New-Object System.Windows.Forms.Button
$copyBtn.Text = "COPY"
$copyBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$copyBtn.Size = New-Object System.Drawing.Size(210, 45)
$copyBtn.Location = New-Object System.Drawing.Point(250, 310)
$copyBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 153, 51)
$copyBtn.ForeColor = [System.Drawing.Color]::White
$copyBtn.FlatStyle = "Flat"
$form.Controls.Add($copyBtn)

# Generate function
function Generate-Password {
    param([int]$Length, [bool]$Upper, [bool]$Lower, [bool]$Numbers, [bool]$Symbols)
    
    $chars = ""
    if ($Upper) { $chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    if ($Lower) { $chars += "abcdefghijklmnopqrstuvwxyz" }
    if ($Numbers) { $chars += "0123456789" }
    if ($Symbols) { $chars += "!@#$%^&*()_+-=[]{}|;:,.<>?" }
    
    if ($chars -eq "") { $chars = "abcdefghijklmnopqrstuvwxyz" }
    
    $password = ""
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    
    for ($i = 0; $i -lt $Length; $i++) {
        $bytes = New-Object byte[] 1
        $rng.GetBytes($bytes)
        $index = $bytes[0] % $chars.Length
        $password += $chars[$index]
    }
    
    return $password
}

# Calculate strength
function Get-PasswordStrength {
    param([string]$Password)
    
    $score = 0
    if ($Password.Length -ge 8) { $score++ }
    if ($Password.Length -ge 12) { $score++ }
    if ($Password.Length -ge 16) { $score++ }
    if ($Password -match "[A-Z]") { $score++ }
    if ($Password -match "[a-z]") { $score++ }
    if ($Password -match "[0-9]") { $score++ }
    if ($Password -match "[!@#$%^&*]") { $score++ }
    
    switch ($score) {
        {$_ -le 2} { return @{Score=25; Text="WEAK"; Color=[System.Drawing.Color]::Red} }
        {$_ -le 4} { return @{Score=50; Text="MEDIUM"; Color=[System.Drawing.Color]::Orange} }
        {$_ -le 5} { return @{Score=75; Text="STRONG"; Color=[System.Drawing.Color]::Yellow} }
        default { return @{Score=100; Text="VERY STRONG"; Color=[System.Drawing.Color]::Lime} }
    }
}

# Generate button click
$generateBtn.Add_Click({
    $password = Generate-Password -Length $lengthSlider.Value -Upper $uppercaseBox.Checked -Lower $lowercaseBox.Checked -Numbers $numbersBox.Checked -Symbols $symbolsBox.Checked
    $passwordBox.Text = $password
    
    $strength = Get-PasswordStrength -Password $password
    $strengthBar.Value = $strength.Score
    $strengthLabel.Text = "Strength: $($strength.Text)"
    $strengthLabel.ForeColor = $strength.Color
    $strengthBar.ForeColor = $strength.Color
})

# Copy button click
$copyBtn.Add_Click({
    if ($passwordBox.Text -ne "") {
        [System.Windows.Forms.Clipboard]::SetText($passwordBox.Text)
        $copyBtn.Text = "COPIED!"
        $copyBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 100, 0)
        Start-Sleep -Milliseconds 1000
        $copyBtn.Text = "COPY"
        $copyBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 153, 51)
    }
})

# Generate initial password
$generateBtn.PerformClick()

# Show form
$form.ShowDialog() | Out-Null
