'MCT Roboter                                                    Datum:  29.01.2020
'                                                               Torben Schweren
'
'Aufgabe:
'Roboter geradeaus fahren lassen
'
'Hardware:
'Taster f�r Kollisionserkennung an PortD.2
'LDR Rechts an PortC.0
'LDR Links an PortC.1
'
'Motoren durch H-Br�cke an Ports
'PortB.1
'PortB.2
'PortB.4
'PortB.5
'PortD.4
'PortD.5
'----------------------------------Deklaration----------------------------------
'Mikrocontroller-Einstellungen
$regfile = "m168def.dat"                                    'ATmega168-Deklaration
$crystal = 20000000                                         'Taktfrequennz: 20,000 MhZ
$hwstack = 100
$swstack = 100
$framesize = 100
$baud = 9600

'Port f�r Kollisionstaster
Ddrd.2 = 1                                                  'PortD.2 als Ausgang festlegen
Portd.2 = 1                                                 'Pull-Up f�r Taster an PortD.2 einschalten

'Ports f�r H-Br�cke / Motoren
Ddrb.1 = 1
Ddrb.2 = 1
Ddrb.4 = 1
Ddrb.5 = 1
Ddrd.4 = 1
Ddrd.5 = 1

'Pulsweitenmodulation um Motorgeschwindigkeit zu steuern
Config Timer0 = Pwm , Prescale = 64                         'Timer im PWM-Modus, jeden 64. Tick ausl�sen lassen
On Timer0 On_pwm                                            'Timer On_Pwm ausl�sen lassen
Dim Timer0_value As Byte                                    'Variable, welche jetzigen Timer-Wert enth�lt
Dim Timer0_frequency As Byte                                'Variable, welche die Geschwindigkeit des Timers bestimmt

'Interrupt f�r Kollisionstaster
Enable Int0                                                 'Interrupt 0 einschalten
On Int0 On_kollision                                        'Beim Interrupt On_Kollision ausf�hren
Config Int0 = Falling                                       'H/L-Flanke f�r INT0

Enable Interrupts                                           'Interrupts generell aktivieren

'Aliase
Ktaster Alias Pind.2
Ldrr Alias Pinc.0
Ldrl Alias Pinc.1

'Konstanten f�r Motoren (wird zum Vergleichen benutzt)
Const Motor_links = 3120
Const Motor_rechts = 3121
Const Motor_vor = 3122
Const Motor_rueck = 3123
Const Motor_stop = 3124

'Variablen
Dim Count As Integer                                        'Benutzt f�r Loops
Count = 0

'Subs Deklarieren
Declare Sub Setmotor(byval Motor As Single , Byval Richtung As Single)
'-------------------------------------Init-------------------------------------'

'-------------------------------------Main--------------------------------------
Do
  Print "Loop"
  Call Setmotor(motor_rechts , Motor_vor)
  Call Setmotor(motor_links , Motor_vor)
  Waitms 500
  Call Setmotor(motor_rechts , Motor_stop)
  Call Setmotor(motor_links , Motor_stop)
  Waitms 2000
Loop
End
'------------------------------------Labels-------------------------------------

'-------------------------------------Subs--------------------------------------
Sub Setmotor(byval Motor As Single , Byval Richtung As Single)
  Select Case Richtung
    Case Motor_stop
      Select Case Motor
        Case Motor_links
          Portb.1 = 0
          Portd.4 = 0
          Portd.5 = 0
          Print "Motor Stop: Links"
        Case Motor_rechts
          Portb.2 = 0
          Portb.4 = 0
          Portb.5 = 0
          Print "Motor Stop: Rechts"
      End Select
    Case Motor_vor
      Select Case Motor
        Case Motor_links
          Portb.1 = 1
          Portd.4 = 1
          Portd.5 = 0
          Print "Motor Vor: Links"
        Case Motor_rechts
          Portb.2 = 1
          Portb.4 = 0
          Portb.5 = 1
          Print "Motor Vor: Rechts"
      End Select
    Case Motor_rueck
      Select Case Motor
        Case Motor_links
          Portb.1 = 1
          Portd.4 = 0
          Portd.5 = 1
          Print "Motor Rueck: Links"
        Case Motor_rechts
          Portb.2 = 1
          Portb.4 = 1
          Portb.5 = 0
          Print "Motor Rueck: Rechts"
      End Select
  End Select
End Sub

'----------------------------------Interrupts-----------------------------------
On_pwm:                                                     'Schaltet den Buzzer in unterschiedlichen Abst�nden ein und aus, um T�ne zu erzeugen
   Timer0_value = Timer0 + 9                                'Genauigkeit verbesser, der MC braucht etwa 9 Ticks, um die Werte neu zu setzen
   Timer0 = Timer0_frequency + Timer0_value
Return

On_kollision:

Return