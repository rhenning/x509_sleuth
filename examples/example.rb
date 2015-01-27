#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'x509_sleuth'

scanner = X509Sleuth::Scanner.new
scanner.add_target("www.google.com")
scanner.run

output = X509Sleuth::ScannerPresenter.new(scanner)
puts output.to_s