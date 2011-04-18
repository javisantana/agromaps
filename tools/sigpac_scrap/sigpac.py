"""
execute:
    $ python sigpac.py

provinces.csv and municipality.csv will be generated
you need to install BeautifulSoup
"""

import os
import sys
import logging
import urllib2
import urllib
import re
import threading
from multiprocessing import Process, Queue
import csv

from BeautifulSoup import BeautifulStoneSoup
SIGPAC_SERVER = "http://sigpac.mapa.es/fega/visor/"
COMUNINDADES="Data.aspx?method=Data&LAYER=COMUNIDADES"
PROVINCIAS= "Data.aspx?method=Data&LAYER=PROVINCIAS&"
MUNICIPIOS= "data.aspx?method=Data&LAYER=MUNICIPIOS&"
POLIGONOS= "data.aspx?method=Data&LAYER=POLIGONOS&"
PARCELAS = "data.aspx?method=Data&LAYER=PARCELAS&"

def fetch_url(url, params={}): 
  logging.debug("--------------- catastro request ------------------"); 
  logging.debug("url: " + url); 
  logging.debug("params: " + str(params)); 
  p = urllib.urlencode(params)
  data = urllib2.urlopen(url+p).read() 
  #import pdb; pdb.set_trace()
  logging.debug(data.decode('utf-8'))
  return data; 



def extract_pos(data):  
    def attr(x):
        return data.find(x).contents[0]
    attrs = ['zone', 'datum', 'xmin', 'ymin', 'xmax', 'ymax']
    return dict(zip(attrs, [attr(x) for x in attrs]))

def parse_code_name(data):
  prov = []
  name_re = re.compile('([^\(]+)')
  for d in BeautifulStoneSoup(data).findAll('datarow'):
        name = name_re.match(d.find('name').contents[0]).groups()[0].strip()
        code = d.find('code').contents[0]
        loc = extract_pos(d)
        prov.append((code, name, loc))
  return prov

def comunindades():
  """ retorna la lista de provincias en espaa """
  data = fetch_url(SIGPAC_SERVER + COMUNINDADES)
  return parse_code_name(data)


def provincias(comunidad):
  data = fetch_url(SIGPAC_SERVER + PROVINCIAS, {'cm': comunidad} )
  return parse_code_name(data)
    
def municipios(provincia):
  data = fetch_url(SIGPAC_SERVER + MUNICIPIOS, {'pr': provincia} )
  return parse_code_name(data)

def poligonos(provincia, poblacion):
  data = fetch_url(SIGPAC_SERVER + POLIGONOS, {'pr': provincia, 'mn': poblacion} )
  return parse_code_name(data)

def parcelas(provincia, poblacion, poligono):
  data = fetch_url(SIGPAC_SERVER + PARCELAS, {'pr': provincia, 'mn': poblacion, 'pl': poligono} )
  return parse_code_name(data)

 

def get_mun(p, n):
    name = "mn_%s_%s.bin" % (p, n)
    if not os.path.exists(name):
        polis = poligonos(p, n)
        polis_data = {}
        for pol in polis:
            polis_data[pol[0]] = parcelas(p, n, pol[0])
        pickle.dump(polis_data, open(name,  'wb'))

def get_all():
    prov_csv = csv.writer(open('provinces.csv', 'wb'), delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
    mun_csv = csv.writer(open('municipality.csv', 'wb'), delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
    prov_csv.writerow(['id', 'name', 'bbox_xmin', 'bbox_ymin', 'bbox_xmax', 'bbox_ymax'])
    mun_csv.writerow(['id', 'province_id', 'name', 'bbox_xmin', 'bbox_ymin', 'bbox_xmax', 'bbox_ymax'])

    def normalize(s):
        return s.replace('"','').replace(',', '').encode('utf-8')

    for c in comunindades():
        for p in provincias(c[0]):
            bbox = p[2]
            prov_csv.writerow([p[0], normalize(p[1]), bbox['xmin'], bbox['ymin'], bbox['xmax'], bbox['ymax']])
            print p[1]
            for m in municipios(p[0]):
                bbox = m[2]
                mun_csv.writerow([m[0], p[0], normalize(m[1]), bbox['xmin'], bbox['ymin'], bbox['xmax'], bbox['ymax']])
                print "\t", m[1]

if __name__ == '__main__':
  get_all()

