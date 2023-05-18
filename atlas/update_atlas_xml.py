"""Reads the content of the LUT.csv and updates the xml file with the ROI names."""

from rich import print
import pandas as pd
import xml.etree.ElementTree as ET
from pathlib import Path

lut_file = (
    Path(__file__).parent
    / "visual_topography_probability_atlas"
    / "LUT.csv"
)

df = pd.read_csv(lut_file, sep=",")

xml_file = (
    Path(__file__).parent
    / "space-MNI_atlas-wang_dseg.xml"
)

mytree = ET.parse(xml_file)
print(mytree)
myroot = mytree.getroot()

for label in myroot.iter("label"):

    index = label.find('index').text
    name = label.find('name').text
    print(f"XML: {index} - {name}")

    df_row = df.loc[df['label'] == int(index)]
    ROI = df_row['ROI'].values[0]
    print(f"LUT: {index} - {ROI}")

    if name != ROI:
        print(f"Updating {name} to {ROI}")
        label.find('name').text = ROI

mytree.write(xml_file)
