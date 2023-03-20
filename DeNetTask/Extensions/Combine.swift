//
//  Combine.swift
//  DeNetTask
//
//  Created by Артур Кулик on 20.03.2023.
//

import Combine

extension CurrentValueSubject {
    func refresh() {
        self.send(self.value)
    }
}
