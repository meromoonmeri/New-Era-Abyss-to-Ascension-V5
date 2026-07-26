#!/usr/bin/env python3
"""Correctif spatial standard conforme directive 12-14.

Ce script ne micro-ajuste pas les maps : il relance la refonte par clonage de
Grounds sources éprouvés, puis reconstruit l'index de tilesets.
"""
import runpy
runpy.run_path('tools/integrate_source_grounds.py', run_name='__main__')
