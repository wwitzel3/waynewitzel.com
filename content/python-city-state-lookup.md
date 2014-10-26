---
categories: ["python"]
tags: ["python", "snippets"]
date: 2010/12/29 11:53:00
title: City and state lookup from zipcode
---
We wanted to be able to present the user with an input box for their zip and then determine the city state for that zipcode. We don't care about city aliases we just want to get the proper city name. I was given a file from zip-codes.com and told to make it so. This was going to be rather simple and boring. Part of the requirement was to have a tuple returned that contained city, state, short state, and zip code when doing lookups. The other part was easily handling the infrequent updates. After looking at the <a href="http://www.zip-codes.com/files/sample_database/zip-codes-database-STANDARD-SAMPLE.zip">sample data</a> and determining that their main file is CSV but all of their updates are sent out at Tab delimited. Honestly that made me happy because it was great excuse to use csv.Sniffer. So here is the Django model I ended up with.

<p>
<pre class="brush: py">
from django.db import models
from django.core.exceptions import ObjectDoesNotExist
from csv import Sniffer, DictReader

# Not sold on this name, but couldn't think of a better one.
class Location(models.Model):
    """
    location / zipcode lookup table
    """
    
    zipcode = models.CharField(max_length=5, unique=True, db_index=True)
    city = models.CharField(max_length=150)
    state = models.CharField(max_length=150)
    state_abbrv = models.CharField(max_length=2)
    
    @classmethod
    def load(cls, filename):
        """
        reads filename, attempts to determine if it is comma or tab delimited
        creates or updates records based on ZipCode and PrimaryRecord key pair
        the following fields must exist in the file: ZipCode, PrimaryRecord,
        CityMixedCase, StateFullName, State
        """
        
        csv_fd = open(filename, 'r')
        
        # grab the header for Sniffer
        # reset the position back to the start of the file
        csv_header = csv_fd.readline()
        csv_fd.seek(0)
        
        # determine if we are CSV or Tab delimited
        dialect = Sniffer().sniff(csv_header)
        csv_dict = DictReader(csv_fd, dialect=dialect)
        
        for row in csv_dict:
            if row['PrimaryRecord'] == "P":
                zipcode = row['ZipCode']
                ZL, created = cls.objects.get_or_create(zipcode=zipcode)
                ZL.zipcode = zipcode
                ZL.city = row['CityMixedCase']
                ZL.state = row['StateFullName']
                ZL.state_abbrv = row['State']
                ZL.save()
                
    @classmethod
    def lookup(cls, zipcode):
        """
        given a zipcode will lookup, populate, and return a tuple with
        city, state, zip information else return unavailable and searched zipcode
        """
        
        try:
            zl = cls.objects.get(zipcode=zipcode)
            return (zl.city, zl.state, zl.state_abbrv, zipcode)
        except ObjectDoesNotExist:
            return (('unavailable',) * 3) + (zipcode,)
</pre>
</p>
