require 'strscan'

# No mas de 50 cocheras
# Arbol no mas de 10 niveles
# cocheras capacidad no mas de 500
# Trenes de no mas de 200 vagones
class Practica

  def metod(data)
    scanner = StringScanner.new(data)
    # M i n 
    m = grab_next_int scanner
    n = grab_next_int scanner
    raise "Formato chungo!" if (m > 50 or n > 10)
    # estaciones
    num_estaciones = (1 << n) - 1
    estaciones = Array.new(num_estaciones)
    leer_estaciones(scanner, 0, 0, 0, n, estaciones)
    # cocheras
    cocheras = Array.new(m)
    prioridades = Array.new(m)
    for i in 1..m do
      c = grab_next_int scanner
      raise "Formato chungo!" if c > 500
      cocheras[i - 1] = { capacidad: c, via: [] }
      prioridades[grab_next_int(scanner) - 1] = i - 1
    end
    # trenes
    trenes = {}
    num_trenes = grab_next_int scanner
    raise "Formato chungo!" if num_trenes > num_estaciones - 1
    for i in 1..num_trenes do
      id_tren = grab_next_int scanner
      num_vagones = grab_next_int scanner
      raise "Formato chungo!" if num_vagones > 200
      vagones = []
      for j in 1..num_vagones do
        vagon = grab_next_int scanner
        vagones << vagon
      end
      trenes[id_tren] = vagones
    end
    # bucle
    output = ""
    opcion = grab_next_int_neg scanner
    while (opcion != -6)
      case opcion
      when -1
        # Almacenamiento nocturno
        num_trenes = grab_next_int scanner
        trenes_alm = []
        for i in 1..num_trenes do
          id_tren = grab_next_int scanner
          hora = grab_next_int scanner
          minuto = grab_next_int scanner
          hora_llegada = (hora * 60 + minuto) + estaciones[id_tren]
          trenes_alm << { id: id_tren, hora_llegada: hora_llegada, vagones: trenes[id_tren] }
        end
        trenes_alm.sort! do |a, b| 
          pr = a[:hora_llegada] <=> b[:hora_llegada] 
          pr = a[:id] <=> b[:id] if pr == 0
          pr
        end
        output += "Horarios para el almacenamiento nocturno\n"
        trenes_alm.each do |t|
          hora = (t[:hora_llegada] / 60) % 24
          minuto = t[:hora_llegada] % 60
          output += "Tren " + t[:id].to_s + " H. " + hora.to_s + " M. " + minuto.to_s + "\n"
          prioridades.each do |p|
            espacio = cocheras[p][:capacidad] - cocheras[p][:via].length
            if (t[:vagones].length <= espacio)
              t[:vagones].each { |v| cocheras[p][:via] << v }
              break
            end
          end
        end
        output += "\n"
      when -2
        # Formacion matinal
        num_trenes = grab_next_int scanner
        trenes_for = []
        for i in 1..num_trenes do
          id_tren = grab_next_int scanner
          trenes_for << { id: id_tren, vagones: trenes[id_tren] }
        end
        aux = []
        output += "Movimientos para la formacion matinal"
        trenes_for.each do |t|
          i = j = 0
          output += "\n  Tren #{t[:id]} :\n"
          output += "    Cochera #{prioridades[i] + 1} :"
          while (j < t[:vagones].length)
            v = t[:vagones][j]
            vm = cocheras[prioridades[i]][:via]
            d_v = vm.reverse.index(v)
            d_a = aux.reverse.index(v)
            ndv = !d_v.nil? 
            nda = !d_a.nil?
            if (ndv || nda)
              if ( (ndv && nda && (d_v + 1 < d_a + 2)) || (ndv && !nda) )
                while (vm.last != v)
                  aux << vm.last
                  output += " 2 " + vm.last.to_s + ' '
                  vm.pop
                end
                output += " 1 " + vm.last.to_s + ' '
                vm.pop
              else
                while (aux.last != v)
                  vm << aux.last
                  output += " 3 " + aux.last.to_s + ' '
                  aux.pop
                end
                output += " 3 " + aux.last.to_s + "  1 " + aux.last.to_s + ' '
                aux.pop
              end
              j += 1
            else
              aux.reverse.each { |a| vm << a }
              aux = []
              i += 1
              output += "\n    Cochera #{prioridades[i] + 1} :"
            end
          end
          aux.reverse.each { |a| cocheras[prioridades[i]][:via] << a }
          aux = []
        end
        output += "\n\n"
      when -3
        # Leer tren
        id_tren = grab_next_int scanner
        num_vagones = grab_next_int scanner
        raise "Formato chungo!" if num_vagones > 200
        vagones = []
        for j in 1..num_vagones do
          vagon = grab_next_int scanner
          vagones << vagon
        end
        trenes[id_tren] = vagones
      when -4
        # Leer cocheras
        for i in 1..m do
          c = grab_next_int scanner
          raise "Formato chungo!" if c > 500
          cocheras[i - 1][:capacidad] = c
          prioridades[grab_next_int(scanner) - 1] = i - 1
        end
      when -5
        # Escribir cocheras
        output += "Cocheras\n"
        for i in 1..cocheras.length do
          output += i.to_s + " : " + cocheras[i - 1][:via].join(" ") + "\n"
        end
        output += "\n"
      end
      opcion = grab_next_int_neg scanner
    end
    output
  end
  
  def grab_next_int(scanner)
    digit = scanner.scan_until(/\d+/)
    raise 'Formato chungo' if (digit.nil? || digit.to_i < 0)
    digit.to_i
  end
  
  def grab_next_int_neg(scanner)
    digit = scanner.scan_until(/\d+/)
    raise 'Formato chungo' if (digit.nil? || digit.to_i >= 0)
    digit.to_i
  end
  
  def leer_estaciones(scanner, tot, i, p, n, estaciones)
    if (p < n)
      t = tot + grab_next_int(scanner)
      estaciones[i] = t
      leer_estaciones(scanner, t, i * 2 + 1, p + 1, n, estaciones)
      leer_estaciones(scanner, t, i * 2 + 2, p + 1, n, estaciones)
    else
      grab_next_int_neg scanner
    end
  end
  
end