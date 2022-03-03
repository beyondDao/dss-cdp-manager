// SPDX-License-Identifier: AGPL-3.0-or-later

/// GetCdps.sol

// Copyright (C) 2018-2020 Maker Ecosystem Growth Holdings, INC.

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity >=0.6.12;

import "./DssCdpManager.sol";

interface VatGet {
    function urns(bytes32, address) external view returns (uint, uint);
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
}

contract GetCdps {
    function getCdpsAsc(address manager, address guy) external view returns (uint[] memory ids, address[] memory urns, bytes32[] memory ilks) {
        uint count = DssCdpManager(manager).count(guy);
        ids = new uint[](count);
        urns = new address[](count);
        ilks = new bytes32[](count);
        uint i = 0;
        uint id = DssCdpManager(manager).first(guy);

        while (id > 0) {
            ids[i] = id;
            urns[i] = DssCdpManager(manager).urns(id);
            ilks[i] = DssCdpManager(manager).ilks(id);
            (,id) = DssCdpManager(manager).list(id);
            i++;
        }
    }

    function getCdpsDesc(address manager, address guy) external view returns (uint[] memory ids, address[] memory urns, bytes32[] memory ilks) {
        uint count = DssCdpManager(manager).count(guy);
        ids = new uint[](count);
        urns = new address[](count);
        ilks = new bytes32[](count);
        uint i = 0;
        uint id = DssCdpManager(manager).last(guy);

        while (id > 0) {
            ids[i] = id;
            urns[i] = DssCdpManager(manager).urns(id);
            ilks[i] = DssCdpManager(manager).ilks(id);
            (id,) = DssCdpManager(manager).list(id);
            i++;
        }
    }

    function getCdpInfo(address manager, uint cdp) external view returns (uint ink, uint art) {
        address urnHandler = DssCdpManager(manager).urns(cdp);
        require(urnHandler != address(0), "invalid Cdp");

        bytes32 ilks = DssCdpManager(manager).ilks(cdp);

        (ink, art) = VatGet(DssCdpManager(manager).vat()).urns(ilks, urnHandler);

    }

    function getIlkInfo(address manager, bytes32 ilk) external view returns (uint256 Art, uint256 rate, uint256 spot, uint256 line, uint256 dust) {
        (Art, rate, spot, line, dust) = VatGet(DssCdpManager(manager).vat()).ilks(ilk);
    }
}
