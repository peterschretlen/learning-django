# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('user_profile', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Note',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('text', models.CharField(max_length=160)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('user', models.ForeignKey(to='user_profile.User')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
