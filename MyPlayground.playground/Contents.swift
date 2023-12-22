import Cocoa

//MARK: - Estructuras - Cliente - Reserva - Errores de reserva


struct Client {
    let name: String
    let age: Int
    let height: Float
}

struct Reservation {
    let id: Int
    let hotelName: String
    let clients: [Client]
    let duration: Int
    let price: Double
    let breakfast: Bool
}

enum ReservationError: Error {
    case duplicateID
    case clientHasReservation
    case reservationNotFound
}

//MARK: - Clase HotelReservationManager


struct HotelReservationManager {
    private let basePrice = 20
     var reservations: [Reservation] = []
    private var reservationIDCounter: Int = 1
    
   mutating func addReservation(clients : [Client], duration: Int, breakfast: Bool) throws -> Reservation {
       
       for client in clients {  // ciclo que verifica si el cliente ya tiene una reserva
           for reservation in reservations {
               for reservationClient in reservation.clients {
                   if client.name == reservationClient.name {
                       throw ReservationError.clientHasReservation
                   }
               }
           }
        }
       
       let finalPrice = clients.count * basePrice * duration * (breakfast ? Int(1.25) : 1) // cálculo del precio
       
       let newReservation = Reservation(id: reservationIDCounter, hotelName: "Hotel 1", clients: clients, duration: duration, price: Double(finalPrice), breakfast: breakfast)
       
       if reservations.contains(where: {$0.id == newReservation.id}) { // verifica que el id sea único
           throw ReservationError.duplicateID
       }
       
       reservations.append(newReservation)
        reservationIDCounter += 1
       
       return newReservation
       
       
    }
    
   mutating func cancelReservation(id: Int) throws {
        guard let index = reservations.firstIndex(where: {$0.id == id}) else{
            throw ReservationError.reservationNotFound
        }
        reservations.remove(at: index)
    }
    
    func allReservations() -> [Reservation] {
        return reservations
    }
}

//MARK: - Pruebas


func testAddReservation() {
    var manager = HotelReservationManager()
    let cliente1 = Client(name: "Juan", age: 35, height: 1.90)
    let cliente2 = Client(name: "Pedro", age: 40, height: 1.80)
    let cliente3 = Client(name: "Diego", age: 30, height: 1.70)
    

    // Añade reserva
    do{
        let reservation1 = try manager.addReservation(clients: [cliente1,cliente2], duration: 3, breakfast: true)
        assert(manager.reservations.count == 1)
        assert(manager.reservations.first?.id == reservation1.id)
    } catch {
        assertionFailure("Reserva no ingresada")
    }
    // Reserva Cliente duplicado
    do{
        let reservation1 = try manager.addReservation(clients: [cliente1,cliente2], duration: 3, breakfast: true)
        let reservation2 = try manager.addReservation(clients: [cliente2], duration: 3, breakfast: true)
    } catch {
        print("Error \(error)")
        //assertionFailure("Esto no debe ocurrir")
    }
    
    
}

func testCancelReservation() {
    var manager = HotelReservationManager()
    let cliente1 = Client(name: "Juan", age: 35, height: 1.90)
    let cliente2 = Client(name: "Pedro", age: 40, height: 1.80)
    let cliente3 = Client(name: "Diego", age: 30, height: 1.70)

  
    do{
        let reservation1 = try manager.addReservation(clients: [cliente1], duration: 3, breakfast: true)
        let reservation2 = try manager.addReservation(clients: [cliente2], duration: 3, breakfast: true)
        manager.allReservations()
        try manager.cancelReservation(id: 1)
        
        manager.allReservations()
        //try manager.cancelReservation(id: 1)
    }catch{
        print("Error \(error)")
        assertionFailure("Esto no debe ocurrir")
    }
}

func testReservationPrice() {
    
    var manager = HotelReservationManager()
    let cliente1 = Client(name: "Juan", age: 35, height: 1.90)
    let cliente2 = Client(name: "Pedro", age: 40, height: 1.80)
  
    
    let cliente3 = Client(name: "Cristian", age: 40, height: 1.80)
    let cliente4 = Client(name: "Diego", age: 30, height: 1.70)
    
    do{
        let reservation1 = try manager.addReservation(clients: [cliente1], duration: 3, breakfast: true)
        let reservation2 = try manager.addReservation(clients: [cliente2], duration: 3, breakfast: true)
        assert(reservation1.price == reservation2.price)
        reservation1.price
        reservation2.price
    }catch{
        assertionFailure("Esto no debe ocurrir")
    }
    
    
}

testAddReservation()
testCancelReservation()
testReservationPrice()

