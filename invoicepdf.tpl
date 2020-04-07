<?php

# Logo
$logoFilename = 'placeholder.png';
if (file_exists(ROOTDIR . '/assets/img/logo.png')) {
    $logoFilename = 'logo.png';
} elseif (file_exists(ROOTDIR . '/assets/img/logo.jpg')) {
    $logoFilename = 'logo.jpg';
}
$pdf->Image(ROOTDIR . '/assets/img/' . $logoFilename, 15, 25, 75);

# Invoice Status
$pdf->SetXY(0, 0);
$pdf->SetFont($pdfFont, 'B', 28);
$pdf->SetTextColor(255);
$pdf->SetLineWidth(0.75);
$pdf->StartTransform();
$pdf->Rotate(-35, 100, 225);
if ($status == 'Draft') {
    $pdf->SetFillColor(200);
    $pdf->SetDrawColor(140);
} elseif ($status == 'Paid') {
    $pdf->SetFillColor(151, 223, 74);
    $pdf->SetDrawColor(110, 192, 70);
} elseif ($status == 'Cancelled') {
    $pdf->SetFillColor(200);
    $pdf->SetDrawColor(140);
} elseif ($status == 'Refunded') {
    $pdf->SetFillColor(131, 182, 218);
    $pdf->SetDrawColor(91, 136, 182);
} elseif ($status == 'Unpaid') {
    $pdf->SetFillColor(255);
    $pdf->SetDrawColor(255);
} elseif ($status == 'Collections') {
    $pdf->SetFillColor(3, 3, 2);
    $pdf->SetDrawColor(127);
} else {
    $pdf->SetFillColor(223, 85, 74);
    $pdf->SetDrawColor(171, 49, 43);
}
if ($status == 'Payment Pending'){
$pdf->Cell(100, 18, strtoupper(Lang::trans('invoices' . str_replace(' ', '', $status))), 'TB', 0, 'C', '1');
} else {
$pdf->Cell(100, 18, strtoupper(Lang::trans('invoices' . strtolower($status))), 'TB', 0, 'C', '1');
}
$pdf->StopTransform();
$pdf->SetTextColor(0);

# Company Details
$pdf->SetXY(15, 42);
$pdf->Ln(10);
$pdf->Ln(5);

# Header Bar

/**
 * Invoice header
 *
 * You can optionally define a header/footer in a way that is repeated across page breaks.
 * For more information, see http://docs.whmcs.com/PDF_Invoice#Header.2FFooter
 * 
 */

 # Header - GAF
$pdf->SetFont($pdfFont, '', 10);
$tblhtml = '<table width="100%" cellpadding="2">
<tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;border-color:#fff;">
    <td align="left">' . $pagetitle . '</td>
    <td align="left"></td>
    <td align="left"></td>
    <td align="left"></td>
</tr>';
$tblhtml .= '
<tr height="30" bgcolor="#ffffff" style="font-weight:normal;">
    <td align="left">' . Lang::trans('invoicesdatecreated') . ': ' . '</td>
    <td align="left">' .  $datecreated . '</td>
    <td align="left">MwSt. Nr.:</td>
    <td align="left">CHE-313.807.947</td>
</tr>
<tr height="30"  bgcolor="#ffffff" style="font-weight:normal;" >
    <td align="left">' . Lang::trans('invoicesdatedue') . ': ' . '</td>
    <td align="left">' . $duedate . '</td>
    <td align="left">' . Lang::trans('invoicesbalance') . '</td>
    <td align="left">' . $balance  . '</td>
</tr>
</table>';
$pdf->writeHTML($tblhtml, true, false, false , false, '');
$pdf->Ln(10);
$startpage = $pdf->GetPage();

# Clients Details - GAF

$tblhtml = '<table width="100%" cellpadding="1">
    <tr height="30"  bgcolor="#ffffff" style="font-weight:bold;">
        <td width="50%" align="left">' . Lang::trans('invoicesinvoicedto') . '</td>
        <td width="50%" align="right">' . Lang::trans('invoicespayto') . '</td>
    </tr>';
if ($clientsdetails["companyname"]) {
    $tblhtml .= '
    <tr bgcolor="#ffffff">
        <td align="left">' .$clientsdetails["companyname"]. '</td>
        <td align="right">Arteeo GmbH</td>
    </tr>
    <tr bgcolor="#ffffff">
    <td align="left">' . $clientsdetails["firstname"] . ' ' . $clientsdetails["lastname"] . '</td>
    <td align="right">Reinhardstrasse 19</td>
    </tr>
    <tr bgcolor="#ffffff">
    <td align="left">' . $clientsdetails["address1"] . '</td>
    <td align="right">8008 Zürich</td>
    </tr>
    <tr bgcolor="#ffffff">
    <td align="left">' . $clientsdetails["postcode"] . " " . $clientsdetails["city"] .'</td>
    <td align="right"></td>
    </tr>
</table>';
    } else {
        $tblhtml .= '
        <tr bgcolor="#ffffff">
        <td align="left">' . $clientsdetails["firstname"] . ' ' . $clientsdetails["lastname"] . '</td>
        <td align="right">Arteeo GmbH</td>
        </tr>
        <tr bgcolor="#ffffff">
        <td align="left">' . $clientsdetails["address1"] . '</td>
        <td align="right">Reinhardstrasse 19</td>
        </tr>
        <tr bgcolor="#ffffff">
        <td align="left">' . $clientsdetails["postcode"] . " " . $clientsdetails["city"] .'</td>
        <td align="right">8008 Zürich</td>
        </tr>
    </table>';
    }
$pdf->writeHTML($tblhtml, true, false, false, false, '');


if ($customfields) {
    $pdf->Ln();
    foreach ($customfields as $customfield) {
       $pdf->Cell(0, 4, $customfield['fieldname'] . ': ' . $customfield['value'], 0, 1, 'L');
    }
}

$pdf->Ln(10);

# Invoice Items
$tblhtml = '<table width="100%" bgcolor="#ccc" cellspacing="1" cellpadding="2" border="0">
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;">
        <td width="80%">' . Lang::trans('invoicesdescription') . '</td>
        <td width="20%">' . Lang::trans('quotelinetotal') . '</td>
    </tr>';
foreach ($invoiceitems as $item) {
    $tblhtml .= '
    <tr bgcolor="#fff">
        <td align="left">' . nl2br($item['description']) . '<br /></td>
        <td align="center">' . $item['amount'] . '</td>
    </tr>';
}
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">' . Lang::trans('invoicessubtotal') . '</td>
        <td align="center">' . $subtotal . '</td>
    </tr>';
if ($taxname) {
    $tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">' . $taxrate . '% ' . $taxname . '</td>
        <td align="center">' . $tax . '</td>
    </tr>';
}
if ($taxname2) {
    $tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">' . $taxrate2 . '% ' . $taxname2 . '</td>
        <td align="center">' . $tax2 . '</td>
    </tr>';
}
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">' . Lang::trans('invoicescredit') . '</td>
        <td align="center">' . $credit . '</td>
    </tr>
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">' . Lang::trans('invoicestotal') . '</td>
        <td align="center">' . $total . '</td>
    </tr>
</table>';

$pdf->writeHTML($tblhtml, true, false, false, false, '');

$pdf->Ln(5);

# Transactions
$pdf->SetFont($pdfFont, 'B', 12);
$pdf->Cell(0, 4, Lang::trans('invoicestransactions'), 0, 1);

$pdf->Ln(5);

$pdf->SetFont($pdfFont, '', 9);

$tblhtml = '<table width="100%" bgcolor="#ccc" cellspacing="1" cellpadding="2" border="0">
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;">
        <td width="25%">' . Lang::trans('invoicestransdate') . '</td>
        <td width="25%">' . Lang::trans('invoicestransgateway') . '</td>
        <td width="30%">' . Lang::trans('invoicestransid') . '</td>
        <td width="20%">' . Lang::trans('invoicestransamount') . '</td>
    </tr>';

if (!count($transactions)) {
    $tblhtml .= '
    <tr bgcolor="#fff">
        <td colspan="4" align="center">' . Lang::trans('invoicestransnonefound') . '</td>
    </tr>';
} else {
    foreach ($transactions AS $trans) {
        $tblhtml .= '
        <tr bgcolor="#fff">
            <td align="center">' . $trans['date'] . '</td>
            <td align="center">' . $trans['gateway'] . '</td>
            <td align="center">' . $trans['transid'] . '</td>
            <td align="center">' . $trans['amount'] . '</td>
        </tr>';
    }
}
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td colspan="3" align="right">' . Lang::trans('invoicesbalance') . '</td>
        <td align="center">' . $balance . '</td>
    </tr>
</table>';

$pdf->writeHTML($tblhtml, true, false, false, false, '');

# Notes
if ($notes) {
    $pdf->Ln(5);
    $pdf->SetFont($pdfFont, '', 8);
    $pdf->MultiCell(170, 5, Lang::trans('invoicesnotes') . ': ' . $notes);
}

# Konto.Nr - GAF
$pdf->SetFont($pdfFont, '', 8);
$pdf->Ln(5);
$pdf->Cell(180, 4, 'Arteeo GmbH Reinhardstrasse 19 8008 Zürich - IBAN: CH58 0483 5280 7381 9100 1 - MwSt. Nr: CHE-313.807.947', '', '', 'C');

/**
 * Invoice footer
 */
